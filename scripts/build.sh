#!/bin/bash

TARGET="arm-linux-gnueabi"

cd /opt/cross/deps

# These get automatically built with GCC
cd ./gcc-4.9.2
ln -s ../mpfr-3.1.2 mpfr
ln -s ../gmp-6.0.0 gmp
ln -s ../mpc-1.0.2 mpc
ln -s ../isl-0.12.2 isl
ln -s ../cloog-0.18.1 cloog

# We need glibc-ports in order to build a cross-compiled version
cd ../glibc-2.15
ln -s ../glibc-ports-2.15 ports

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
cd /opt/cross/deps/linux-3.16.2
make ARCH=arm INSTALL_HDR_PATH="/opt/cross/${TARGET}" headers_install
cd ../
cd ../builds && mkdir build-gcc && cd build-gcc

../../deps/gcc-4.9.2/configure --prefix=/opt/cross --target="${TARGET}" --enable-languages=c,c++ --disable-multilib

make -j4 all-gcc
make install-gcc

# Build glibc
cd ../ && mkdir build-glibc && cd build-glibc

# Apply our patch to accept make-4.0
cd ../../deps/glibc-2.15
patch < /opt/cross/scripts/glibc_configure_make-4.0.patch
chmod +x configure

cd /opt/cross/builds/build-glibc

../../deps/glibc-2.15/configure --prefix="/opt/cross/${TARGET}" --build="x86_64" --host="${TARGET}" --target="${TARGET}" --with-headers="/opt/cross/${TARGET}/include" --disable-multilib libc_cv_forced_unwind=yes libc_cv_c_cleanup=yes --enable-kernel=3.16.2 --enable-add-ons=nptl,ports libc_cv_ctors_header=yes
make install-bootstrap-headers=yes install-headers
make -j4 csu/subdir_lib
install csu/crt1.o csu/crti.o csu/crtn.o "/opt/cross/${TARGET}/lib"
arm-linux-gnueabi-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o "/opt/cross/${TARGET}/lib/libc.so"
touch "/opt/cross/${TARGET}/include/gnu/stubs.h"

cd ../build-gcc

make -j4 all-target-libgcc
make install-target-libgcc

cd ../build-glibc

make -j4
make install

cd ../build-gcc

make -j4
make install
