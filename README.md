# Welcome!
This docker container provides a GCC 4.9.x and eglibc-2.20 dockerized toolchain for Plum.

Crosstools-ng is built and installed on the host. The `ct-ng` script was used to build a toolchain for 32bit
ARM, GCC 4.9.x, Linux Kernel 3.18.x, and glibc 2.20.x.

The toolchain is symlinked to `/root/x-tools`.

Reproducibility will require extracting the crosstools-ng configuration menu output and using that.
