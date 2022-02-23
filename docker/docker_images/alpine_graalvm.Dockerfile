FROM alpine:latest

ENV GRAAL_VERSION 1.0.0-rc15
ENV GRAAL_DOWNLOAD_URL https://github.com/oracle/graal/releases/download/vm-${GRAAL_VERSION}/graalvm-ce-${GRAAL_VERSION}-linux-amd64.tar.gz
ENV PATH /opt/graal/bin:$PATH
ENV GLIBC_VERSION 2.29-r0
ENV LD_LIBRARY_PATH /lib

# Add prerequisites

RUN apk --no-cache --update add curl ca-certificates wget zlib zlib-dev \
    && rm -rf /var/cache/apk/* \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
    && apk add glibc-${GLIBC_VERSION}.apk \
    && rm glibc-${GLIBC_VERSION}.apk

# Setup GraalVM

RUN cd $HOME \
    && curl -OL $GRAAL_DOWNLOAD_URL \
    && tar xf graalvm-ce-${GRAAL_VERSION}-linux-amd64.tar.gz \
    && rm graalvm-ce-${GRAAL_VERSION}-linux-amd64.tar.gz \
    && mv graalvm-ce-${GRAAL_VERSION} graal \
    && mv graal /opt