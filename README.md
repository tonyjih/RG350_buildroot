# RG350 buildroot

This buildroot can be used to build RG350 cross-compilation toolchain and the OS image.

## Pre-Build Steps

If you are using Debian or Ubuntu, please run:
~~~bash
sudo apt-get update -y
sudo apt-get install -y bison flex gettext texinfo wget cpio mercurial subversion libncurses5-dev libc6-dev-i386 bzr squashfs-tools zip unzip python python3 rsync
~~~

Or if you are using CentOS, please run:

~~~bash
yum update -y
yum install -y autoconf automake bc bison bzip2 flex fontconfig freetype gcc-c++ git glibc-devel glibc-devel.i686 java-1.8.0-openjdk-devel libgcc.i686 libstdc++.i686 m4 make mercurial openssl-devel patch perl-ExtUtils-MakeMaker rsync squashfs-tools subversion zip unzip wget which python3 texinfo
~~~

## Build toolchain

First, clone or download the repo and run:

~~~bash
make rg350_defconfig BR2_EXTERNAL=board/opendingux
~~~

You only need to run this once.

Now, `export BR2_JLEVEL=0` to compile in parallel.

Then, to build the toolchain, run:

~~~bash
make toolchain
~~~

You can also build particular libraries and packages this way, for example to build SDL and SDL_Image:

~~~bash
make sdl sdl_image
~~~

## Build OS image

Optional: If you want to include a set of default applications, emulators, and games
from various sources, run this command (you only need to do this once):

~~~bash
board/opendingux/gcw0/download_local_pack.sh
~~~

To build the OS image, run:

~~~bash
board/opendingux/gcw0/make_initial_image.sh
~~~

The image will saved to:

~~~
output/images/od-imager/images/sd_image.bin
~~~

This image can be flashed directly to the system SD card, e.g. using [balenaEtcher].

[balenaEtcher]: https://www.balena.io/etcher/

## Build OS update OPK (experimental)

To build an updater OPK that can be run directly from the device, run:

~~~bash
board/opendingux/gcw0/make_upgrade.sh
~~~
