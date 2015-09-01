FROM debian:8.1

RUN apt-get update && apt-get install -y subversion curl wget git xz-utils gcc g++ gperf bison flex texinfo bzip2 gawk make libtool libtool-bin automake libncurses5-dev vim

WORKDIR /root

RUN mkdir x-tools
RUN wget http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.21.0.tar.xz && tar xf crosstool-ng-1.21.0.tar.xz
RUN cd crosstool-ng-1.21.0 && ./configure
RUN cd crosstool-ng-1.21.0 && make && make install

CMD bash
