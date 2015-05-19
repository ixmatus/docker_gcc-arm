#!/bin/bash

TARGET="arm-linux-gnueabi"
export PATH=/opt/cross/bin:$PATH

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
