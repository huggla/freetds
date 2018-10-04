FROM alpine:edge

RUN wget -O /tmp/freetds.tar.gz http://www.freetds.org/files/stable/freetds-patched.tar.gz \
 && cd /tmp \
 && tar -xvp -f freetds.tar.gz \
 && ls
