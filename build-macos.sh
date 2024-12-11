#! /bin/bash

set -e

if [ ! -f figlet-2.2.5.tar.gz ]; then
  curl -LO http://ftp.figlet.org/pub/figlet/program/unix/figlet-2.2.5.tar.gz
fi
SHA="bf88c40fd0f077dab2712f54f8d39ac952e4e9f2e1882f1195be9e5e4257417d"
if [ "`sha256sum figlet-2.2.5.tar.gz | cut -d" " -f1`" != "$SHA" ]; then
  >&2 echo Error: SHA mismatch;
  exit 1;
fi

rm -rf figlet-2.2.5
tar xzf figlet-2.2.5.tar.gz
(
  cd figlet-2.2.5
  patch -p1 < ../figlet-macos.patch
  ARCH=arm64 make DEFAULTFONTDIR=/usr/local/share/figlet all
  mv chkfont chkfont-arm64
  mv figlet figlet-arm64
  make clean
  ARCH=x86_64 make DEFAULTFONTDIR=/usr/local/share/figlet all
  mv chkfont chkfont-x86_64
  mv figlet figlet-x86_64
  lipo figlet-arm64 figlet-x86_64 -create -output figlet
  lipo chkfont-arm64 chkfont-x86_64 -create -output chkfont
  mkdir -p build
  make install DESTDIR=build
  cd build
  tar czf ../../figlet-macos-2.2.5-r3.tar.gz .
)
