FROM alpine:latest

ENV ANSIBLE_VERSION 2.9.9
ENV CRYPTOGRAPHY_DONT_BUILD_RUST 1

RUN apk update && \
    apk add \
    py3-pip \
    gcc \
    python3-dev \
    libffi-dev \
    musl-dev \
    openssl-dev \
    && python3 -m pip install --upgrade pip \
    && python3 -m pip install \
    setuptools \
    jmespath \
    influxdb \
    ansible==${ANSIBLE_VERSION}

ADD . $HOME/k8s_pod_events

WORKDIR $HOME/k8s_pod_events
