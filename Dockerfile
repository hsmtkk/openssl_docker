FROM ubuntu:20.04 as builder

RUN apt -y update \
 && apt -y install curl gcc make perl

WORKDIR /usr/local/src

RUN curl -L -O https://www.openssl.org/source/openssl-1.1.1g.tar.gz \
 && tar fxz openssl-1.1.1g.tar.gz \
 && cd openssl-1.1.1g \
 && ./config --prefix=/usr/local/openssl enable-md2 shared \
 && make \
 && make test \
 && make install_sw

FROM ubuntu:20.04

COPY --from=builder /usr/local/openssl /usr/local/openssl

RUN env LD_LIBRARY_PATH=/usr/local/openssl/lib /usr/local/openssl/bin/openssl version
