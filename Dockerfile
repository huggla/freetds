FROM huggla/alpine-official:20181005-edge as alpine

ARG BUILDDEPS="build-base libressl-dev linux-headers readline-dev unixodbc-dev libtool"

RUN downloadDir="$(mktemp -d)" \
 && wget -O $downloadDir/freetds.tar.gz "http://www.freetds.org/files/stable/freetds-patched.tar.gz" \
 && buildDir="$(mktemp -d)" \
 && tar -xvp -f $downloadDir/freetds.tar.gz -C $buildDir --strip-components 1 \
 && rm -rf $downloadDir \
 && apk --no-cache add $BUILDDEPS \
 && cd $buildDir \
 && sed -i '95i#endif' ./src/tds/tls.c \
 && sed -i '96i' ./src/tds/tls.c \
 && sed -i '97i#ifndef TLS_ST_OK' ./src/tds/tls.c \
 && sed -i '28i#include <sys/stat.h>' ./src/apps/fisql/fisql.c \
 && ./configure --prefix=/usr --sysconfdir=/etc --mandir=/usr/share/man --infodir=/usr/share/info --enable-msdblib --with-openssl=/usr --enable-odbc --with-unixodbc=/usr \
 && make \
 && destDir="/apps/freetds" \
 && mkdir -p $destDir $destDir-dev/usr/lib \
 && make -j1 DESTDIR="$destDir" install \
 && rm -rf $buildDir \
 && apk --no-cache --purge del $BUILDDEPS \
 && mv $destDir/usr/include $destDir-dev/usr/ \
 && mv $destDir/usr/lib/*.so $destDir/usr/lib/*.a $destDir-dev/usr/lib/ \
 && rm -rf $destDir/usr/share

FROM scratch as image

COPY /apps /
