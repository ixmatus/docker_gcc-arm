#!/bin/bash

TARGET="arm-linux-eabi"

cd /opt/cross/deps

cd ./gcc-4.9.2
ln -s ../mpfr-3.1.2 mpfr
ln -s ../gmp-6.0.0 gmp
ln -s ../mpc-1.0.2 mpc
ln -s ../isl-0.12.2 isl
ln -s ../cloog-0.18.1 cloog

export PATH=/opt/cross/bin:$PATH

cd /opt/cross/builds

# Build binutils
mkdir build-binutils && cd build-binutils

../../deps/binutils-2.24/configure --prefix=/opt/cross --target="${TARGET}" --disable-multilib --disable-werror
make -j4
make install

cd ../

ls -al /opt/cross/deps

# Build linux headers
cd /opt/cross/deps/linux-3.17.2
make ARCH=arm INSTALL_HDR_PATH="/opt/cross/${TARGET}" headers_install
cd ../
cd ../builds && mkdir build-gcc && cd build-gcc

../../deps/gcc-4.9.2/configure --prefix=/opt/cross --target="${TARGET}" --enable-languages=c,c++ --disable-multilib

make -j4 all-gcc
make install-gcc

# Build glibc
cd ../ && mkdir build-glibc && cd build-glibc

../../deps/glibc-2.20/configure --prefix="/opt/cross/${TARGET}" --build="${MACHTYPE}" --host="${TARGET}" --target="${TARGET}"
make install-bootstrap-headers=yes install-headers
make -j4 csu/subdir_lib
install csu/crt1.o csu/crti.o csu/crtn.o "/opt/cross/${TARGET}/lib"
arm-linux-eabi-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o "/opt/cross/${TARGET}/lib/libc.so"
touch "/opt/cross/${TARGET}/include/gnu/stubs.h"

cd ../
