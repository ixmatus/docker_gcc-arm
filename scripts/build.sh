#!/bin/bash

cd /opt/cross/deps

for f in *.tar*; do tar xf $f; done;

cd ./gcc-4.9.2
ln -s ../mpfr-3.1.2 mpfr
ln -s ../gmp-6.0.0 gmp
ln -s ../mpc-1.0.2 mpc
ln -s ../isl-0.12.2 isl
ln -s ../cloog-0.18.1 cloog
cd /opt/cross
