FROM centos:8 as builder

RUN yum -y update \
 && yum -y install gcc make perl

WORKDIR /usr/local/src

RUN curl -L -O https://www.openssl.org/source/openssl-1.1.1g.tar.gz \
 && tar fxz openssl-1.1.1g.tar.gz \
 && cd openssl-1.1.1g \
 && ./config --prefix=/usr/local enable-md2 shared \
 && make \
 && make test \
 && make install_sw

RUN rm -rf /usr/local/src/*

FROM centos:8

COPY --from=builder /usr/local /usr/local

RUN openssl version
