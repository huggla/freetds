FROM alpine:edge

RUN wget -O /tmp/freetds.tar.gz http://www.freetds.org/files/stable/freetds-patched.tar.gz \
 && cd /tmp \
 && tar -xvp -f freetds.tar.gz \
 && cd freetds-1.00.103 \
 && sed -i '95s/#define TLS_ST_OK SSL_ST_OK/#endif/' ./src/tds/tls.c \
 && sed -i '96s/#endif/#ifndef TLS_ST_OK/' ./src/tds/tls.c \
 && sed -i '97s/.*/#define TLS_ST_OK SSL_ST_OK/' ./src/tds/tls.c \
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
