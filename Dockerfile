ARG TAG="20181106-edge"

FROM huggla/freetds:$TAG as freetds
FROM huggla/alpine-official:$TAG as alpine

ARG RUNDEPS="libressl2.7-libssl unixodbc"

COPY --from=freetds /freetds /

RUN apk --no-cache add $RUNDEPS
