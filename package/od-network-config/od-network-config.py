#!/usr/bin/env python2

from collections import defaultdict
from crypt import crypt
from ctypes import (
	POINTER, Structure, Union, byref, cast, cdll, get_errno, pointer,
	c_void_p, c_char, c_char_p, c_byte, c_ushort, c_int, c_uint,
	c_uint16
	)
from ctypes.util import find_library
from os import (
	O_CREAT, O_EXCL, O_WRONLY,
	fdopen, link, open as osopen, remove, rename, urandom
	)
from os.path import join as joinpath, realpath
from socket import AF_INET, inet_ntop
from spwd import getspnam
from time import time

import pygame


libc = cdll.LoadLibrary(find_library('c'))

def initInterfaceAddrs():
	# Generic socket address.
	sa_family_t = c_ushort
	class struct_sockaddr(Structure):
		_fields_ = (
			('sa_family', sa_family_t),
			('sa_data', c_char * 14),
			)
	struct_sockaddr_p = POINTER(struct_sockaddr)

	# IPv4 socket address.
	struct_in_addr = c_byte * 4
	class struct_sockaddr_in(Structure):
		_fields_ = (
			('sin_family', sa_family_t),
			('sin_port', c_uint16),
			('sin_addr', struct_in_addr),
			)
	struct_sockaddr_in_p = POINTER(struct_sockaddr_in)

	class union_ifa_ifu(Union):
		_fields_ = (
			('ifu_broadaddr', struct_sockaddr_p),
			('ifu_dstaddr', struct_sockaddr_p),
			)

	class struct_ifaddrs(Structure):
		pass
	struct_ifaddrs_p = POINTER(struct_ifaddrs)
	struct_ifaddrs_pp = POINTER(struct_ifaddrs_p)
	struct_ifaddrs._fields_ = (
		('ifa_next', struct_ifaddrs_p),
		('ifa_name', c_char_p),
		('ifa_flags', c_uint),
		('ifa_addr', struct_sockaddr_p),
		('ifa_netmask', struct_sockaddr_p),
		('ifa_ifu', union_ifa_ifu),
		('ifa_data', c_void_p),
		)

	getifaddrs = libc.getifaddrs
	getifaddrs.restype = c_int
	getifaddrs.argtypes = (struct_ifaddrs_pp, )

	freeifaddrs = libc.freeifaddrs
	freeifaddrs.restype = None
	freeifaddrs.argtypes = (struct_ifaddrs_p, )

	global getInterfaceAddrs
	def getInterfaceAddrs():
		'''Returns a new dictionary where the keys are interface names and
		the values are sets of IPv4 addresses in string format.
		'''
		interfaceListPtr = struct_ifaddrs_p()
		result = getifaddrs(byref(interfaceListPtr))
		if result == -1:
			raise OSError(get_errno())
		assert result == 0, result

		ret = defaultdict(set)
		currInterfacePtr = interfaceListPtr
		while currInterfacePtr:
			currInterface = currInterfacePtr.contents
			name = currInterface.ifa_name
			addrPtr = currInterface.ifa_addr
			if not addrPtr:
				continue

			family = addrPtr.contents.sa_family
			if family == AF_INET:
				inetAddr = cast(addrPtr, struct_sockaddr_in_p).contents
				ret[name].add(inet_ntop(family, inetAddr.sin_addr))

			currInterfacePtr = currInterface.ifa_next

		freeifaddrs(interfaceListPtr)
		return ret

initInterfaceAddrs()

LOGIN_DISABLED, LOGIN_PASSWORD, LOGIN_NOPASSWORD = xrange(3)
loginLabels = 'disabled', 'with password', 'without password'

def checkLogin():
	try:
		fields = getspnam('root')
	except KeyError:
		return LOGIN_DISABLED
	if fields.sp_pwd == '':
		return LOGIN_NOPASSWORD
	elif fields.sp_pwd == '*':
		return LOGIN_DISABLED
	else:
		return LOGIN_PASSWORD

def llopen(path, mode, flags, perms = 0o777):
	fd = osopen(path, flags, perms)
	return fdopen(fd, mode)

def updateShadowPassword(user, encryptedPassword):
	def updateFields(fields):
		fields.extend([''] * (9 - len(fields)))
		fields[0] = user
		fields[1] = encryptedPassword
		fields[2] = str(int(time()) / (24 * 60 * 60))

	shadowPath = realpath('/etc/shadow')
	tempPath = shadowPath + '+'
	backupPath = shadowPath + '-'

	with llopen(tempPath, 'w', O_WRONLY | O_CREAT, 0o600) as out:
		userFound = False
		try:
			with open(shadowPath, 'r') as inp:
				for line in inp:
					line = line.strip()
					fields = line.split(':')
					if fields[0] == user:
						userFound = True
						updateFields(fields)
						out.write(':'.join(fields) + '\n')
					else:
						out.write(line + '\n')
		except (IOError, OSError):
			# Treat missing or invalid shadow password file as empty.
			pass
		if not userFound:
			fields = []
			updateFields(fields)
			out.write(':'.join(fields) + '\n')

	try:
		remove(backupPath)
	except OSError:
		pass
	try:
		link(shadowPath, backupPath)
	except OSError:
		pass
	rename(tempPath, shadowPath)

def checkedUpdateShadowPassword(user, encryptedPassword):
	global errorLine
	try:
		updateShadowPassword(user, encryptedPassword)
	except OSError, ex:
		errorLine = str(ex)
		return False
	else:
		errorLine = None
		return True

def doSetRandomPassword():
	saltBytes = 6
	pwBytes = 6
	rnd = urandom(saltBytes + pwBytes)
	salt = rnd[ : saltBytes].encode('base64').rstrip('=').replace('+', '.')
	password = ''.join(
		chr(ord('a') + ord(ch) % 26)
		for ch in rnd[saltBytes : ]
		)

	if checkedUpdateShadowPassword('root', crypt(password, salt)):
		global loginStatus, displayPassword
		displayPassword = password
		loginStatus = LOGIN_PASSWORD

def doSetNoPassword():
	if checkedUpdateShadowPassword('root', ''):
		global loginStatus
		loginStatus = LOGIN_NOPASSWORD

def doSetInvalidPassword():
	if checkedUpdateShadowPassword('root', '*'):
		global loginStatus
		loginStatus = LOGIN_DISABLED

def doExit():
	global exitFlag
	exitFlag = True

def drawStringWithShadow(text, font, pos):
	shadowPos = (pos[0] + 2, pos[1] + 2)
	screen.blit(font.render(text, True, (0, 0, 0)), shadowPos)
	screen.blit(font.render(text, True, (255, 255, 255)), pos)

def drawString(text, font, pos):
	screen.blit(font.render(text, True, (255, 255, 255)), pos)

def paintBackground():
	w, h = screen.get_size()
	grad = 80
	for y in xrange(grad):
		screen.fill((grad - 1 - y, 0, grad - 1 - y), (0, y, w, y))
	screen.fill((0, 0, 0), (0, grad, w, h - grad))

	drawStringWithShadow('Configure Network', titleFont, (8, 4))
	drawStringWithShadow('for FTP, SFTP, Telnet, SSH', normalFont, (8, 36))

def paintStatus():
	statusLine = 'Current setting:  login %s' % loginLabels[loginStatus]
	if errorLine is not None:
		commentLine = errorLine
	elif loginStatus == LOGIN_NOPASSWORD:
		commentLine = 'NOTE:  Anyone on the network can log in!'
	elif loginStatus == LOGIN_PASSWORD and displayPassword is not None:
		commentLine = 'Password:  %s' % displayPassword
	else:
		commentLine = ''

	drawString(ipAddrLine, normalFont, (8, 72))
	drawString('Login with user name: root', normalFont, (8, 88))
	drawString(statusLine, normalFont, (8, 114))
	drawString(commentLine, normalFont, (8, 130))

menuOptions = (
	('Set random password', doSetRandomPassword),
	('Allow login without password', doSetNoPassword),
	('Disable password login', doSetInvalidPassword),
	('Exit', doExit),
	)

def paintMenu():
	w, h = screen.get_size()
	y = h - 20 * len(menuOptions)
	for idx, (label, _) in enumerate(menuOptions):
		screen.fill(
			(64, 0, 64) if idx == currentOption else (16, 0, 16),
			(4, y, w - 8, 18)
			)
		drawString(label, normalFont, (8, y))
		y += 20

def paint():
	paintBackground()
	paintStatus()
	paintMenu()

def handleEvent(event):
	global currentOption, exitFlag

	if event.type == pygame.QUIT:
		exitFlag = True
	elif event.type == pygame.KEYDOWN:
		if event.key == pygame.K_UP:
			currentOption = (currentOption - 1) % len(menuOptions)
		elif event.key == pygame.K_DOWN:
			currentOption = (currentOption + 1) % len(menuOptions)
		elif event.key in (pygame.K_LCTRL, pygame.K_RETURN):
			menuOptions[currentOption][1]()
		elif event.key == pygame.K_ESCAPE:
			exitFlag = True

def mainLoop():
	global currentOption, exitFlag
	currentOption = len(menuOptions) - 1
	exitFlag = False

	while not exitFlag:
		paint()
		pygame.display.flip()

		handleEvent(pygame.event.wait())
		for event in pygame.event.get():
			handleEvent(event)

def init():
	global ipAddrLine
	interfaceAddrs = getInterfaceAddrs()
	del interfaceAddrs['lo']
	addrItems = [
		'%s: %s' % (name, ', '.join(sorted(addrs)))
		for name, addrs in sorted(interfaceAddrs.iteritems())
		]
	ipAddrLine = 'IP addrs:  ' + (
		'  '.join(addrItems) if addrItems else '(no network active)'
		)

	global errorLine
	errorLine = None

	pygame.init()
	pygame.mouse.set_visible(False)

	global screen
	screen = pygame.display.set_mode((320, 240), pygame.DOUBLEBUF)

	global titleFont, normalFont
	fontDir = '/usr/share/fonts/dejavu/'
	titleFont = pygame.font.Font(fontDir + 'DejaVuSans-Bold.ttf', 24)
	normalFont = pygame.font.Font(fontDir + 'DejaVuSansCondensed.ttf', 13)

	global loginStatus, displayPassword
	loginStatus = checkLogin()
	displayPassword = None

def exit():
	pygame.quit()

if __name__ == '__main__':
	init()
	mainLoop()
	exit()

# kate: indent-width 4; tab-width 4;
