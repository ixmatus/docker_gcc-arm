#!/bin/bash

TARGET="arm-linux-gnueabi"
export PATH=/opt/cross/bin:$PATH

cd /opt/cross/builds

apt-get install -y file

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

../../deps/gcc-4.9.2/configure --prefix=/opt/cross --target="${TARGET}" --enable-languages=c,c++ --disable-multilib --enable-threads=posix --disable-libquadmath --disable-libquadmathsupport --disable-libgomp

make -j4 all-gcc
make install-gcc

# Build eglibc (this is the nastiest part)
cd ../ && mkdir build-eglibc && cd build-eglibc

# Apply our patch to accept make-4.0
cd ../../deps/eglibc-2.15
# patch < /opt/cross/scripts/glibc_configure_make-4.0.patch
# chmod +x configure

# Apply Makefile patch to the glibc ARM port
cd ../../deps/glibc-2.15/ports/sysdeps/arm
# patch < /opt/cross/scripts/glibc_ports_arm-Makefile.patch

cd /opt/cross/builds/build-eglibc

echo "libc_cv_forced_unwind=yes" > config.cache
echo "libc_cv_c_cleanup=yes"     >> config.cache
echo "libc_cv_ctors_header=yes"  >> config.cache

../../deps/eglibc-2.15/configure --prefix="/opt/cross/${TARGET}" --build="x86_64" --host="${TARGET}" --target="${TARGET}" --with-headers="/opt/cross/${TARGET}/include" --disable-multilib --enable-kernel=3.16.2 --enable-add-ons=nptl,ports --with-tls --with-__thread --cache-file=config.cache --disable-profile
make install-bootstrap-headers=yes install-headers
make -j4 csu/subdir_lib
install csu/crt1.o csu/crti.o csu/crtn.o "/opt/cross/${TARGET}/lib"
arm-linux-gnueabi-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o "/opt/cross/${TARGET}/lib/libc.so"
touch "/opt/cross/${TARGET}/include/gnu/stubs.h"
