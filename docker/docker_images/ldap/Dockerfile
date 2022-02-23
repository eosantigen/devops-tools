FROM alpine:latest

ENV ORGANISATION_NAME "metis.tech"
ENV SUFFIX "dc=metis,dc=tech"
ENV ROOT_USER "admin"
ENV ROOT_PW "admin"
ENV LOG_LEVEL "trace"

RUN apk add --update openldap openldap-back-mdb && \
    mkdir -p /run/openldap /var/lib/openldap/openldap-data && \
    rm -rf /var/cache/apk/*

COPY slapd_conf/* /etc/openldap/
COPY docker-entrypoint.sh /

EXPOSE 389

ENTRYPOINT [ "/docker-entrypoint.sh" ]
