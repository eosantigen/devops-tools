FROM python:3.10.4 as builder

COPY . /build

WORKDIR /build

RUN pip install -r requirements.txt --no-cache-dir --target /build

FROM python:3.10.4-slim

ARG USER
ARG WORKDIR
ARG APP_NAME

ENV APP_NAME ${APP_NAME}

COPY --from=builder /build/ ${WORKDIR}

COPY ${APP_NAME}.py ${WORKDIR}

RUN adduser --system --no-create-home --disabled-password ${USER}

WORKDIR ${WORKDIR}

USER ${USER}

CMD ["sh", "-c", "./${APP_NAME}.py" ]