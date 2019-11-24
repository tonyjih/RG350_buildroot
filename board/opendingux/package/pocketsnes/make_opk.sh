#!/bin/sh

OPK_NAME=PocketSNES.opk

echo ${OPK_NAME}

# create default.gcw0.desktop
cat > default.gcw0.desktop <<EOF
[Desktop Entry]
Name=PocketSNES
Comment=PingFlood SNES Emulator
Exec=PocketSNES.dge %f
Terminal=false
Type=Application
StartupNotify=true
Icon=PocketSNES
Categories=emulators;
EOF

# create opk
FLIST="dist/backdrop.png"
FLIST="${FLIST} dist/control"
FLIST="${FLIST} dist/pocketsnes.lnk"
FLIST="${FLIST} dist/PocketSNES.png"
FLIST="${FLIST} dist/conffiles"
FLIST="${FLIST} dist/PocketSNES.dge"
FLIST="${FLIST} dist/PocketSNES.man.txt"
FLIST="${FLIST} dist/snes.pocketsnes.lnk"
FLIST="${FLIST} default.gcw0.desktop"
FLIST="${FLIST} dist/PocketSNES.png"

rm -f ${OPK_NAME}
mksquashfs ${FLIST} ${OPK_NAME} -all-root -no-xattrs -noappend -no-exports

cat default.gcw0.desktop
rm -f default.gcw0.desktop
