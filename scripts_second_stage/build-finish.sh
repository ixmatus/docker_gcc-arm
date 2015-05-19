#!/bin/bash

TARGET="arm-linux-gnueabi"
export PATH=/opt/cross/bin:$PATH

cd /opt/cross/builds

# Finish off our other pieces
cd ./build-gcc
make -j4 all-target-libgcc
make install-target-libgcc

cd ../build-glibc

make -j4
make install

cd ../build-gcc

make -j4
make install
