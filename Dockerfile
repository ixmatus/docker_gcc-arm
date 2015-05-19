FROM ubuntu:15.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        automake     \
        bc           \
        bison        \
        cmake        \
        curl         \
        flex         \
        git          \
        g++          \
        gcc          \
        gawk         \
        wget         \
        svn          \
        gettext      \
        texinfo      \
        bzip2        \
        xz-utils     \
        lib32stdc++6 \
        lib32z1      \
        ncurses-dev  \
        ;

RUN mkdir /opt/cross
WORKDIR /opt/cross

RUN mkdir /opt/cross/deps
RUN mkdir /opt/cross/builds

RUN cd ./deps && wget http://ftpmirror.gnu.org/binutils/binutils-2.24.tar.gz
RUN cd ./deps && wget http://ftpmirror.gnu.org/gcc/gcc-4.9.2/gcc-4.9.2.tar.gz
RUN cd ./deps && wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.16.2.tar.xz
RUN cd ./deps && svn co svn://svn.eglibc.org/branches/eglibc-2_15 eglibc-2.15
RUN cd ./deps && wget http://ftpmirror.gnu.org/mpfr/mpfr-3.1.2.tar.xz
RUN cd ./deps && wget http://ftpmirror.gnu.org/gmp/gmp-6.0.0a.tar.xz
RUN cd ./deps && wget http://ftpmirror.gnu.org/mpc/mpc-1.0.2.tar.gz

RUN cd /opt/cross/deps && for f in *.tar.*; do tar xf $f; done;

ADD ./scripts /opt/cross/scripts

RUN /opt/cross/scripts/setup.sh
RUN /opt/cross/scripts/build-libs.sh

ADD ./scripts_second_stage /opt/cross/scripts_second_stage

RUN /opt/cross/scripts_second_stage/build-finish.sh
