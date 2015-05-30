#!/bin/sh

if [ -z "$1" -o "x$1" = "xstart" -o "x$1" = "xreload" ]; then
	if [ -r /usr/local/etc/hostname ] ; then
		/bin/hostname -F /usr/local/etc/hostname
	else
		/bin/hostname -F /etc/hostname
	fi
fi
