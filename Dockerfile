FROM alpine:edge

RUN wget -O /tmp/freetds.tar.gz http://www.freetds.org/files/stable/freetds-patched.tar.gz \
 && cd /tmp \
 && tar -xvp -f freetds.tar.gz \
 && cd freetds-1.00.103 \
 && sed -i '95i#endif' ./src/tds/tls.c \
 && sed -i '96i' ./src/tds/tls.c \
 && sed -i '97i#ifndef TLS_ST_OK' ./src/tds/tls.c \
 && sed -i '28i#include <sys/stat.h>' ./src/apps/fisql/fisql.c \
 && apk --no-cache add build-base libressl-dev linux-headers readline-dev unixodbc-dev \
 && ./configure \
		--build=$CBUILD \
		--host=$CHOST \
		--prefix=/usr/local \
		--sysconfdir=/etc \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--enable-msdblib \
		--with-openssl=/usr \
		--enable-odbc \
		--with-unixodbc=/usr \
 && make \
 && mkdir /tmp/apa \
 && make -j1 DESTDIR="/tmp/apa" install
