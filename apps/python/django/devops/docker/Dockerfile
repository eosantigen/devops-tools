FROM python:3.10.4 as builder

COPY . /build

WORKDIR /build

RUN apt update && \
    apt install -y \
    libldap-common \
    libldap-dev \
    libsasl2-dev \
    libssl-dev \
    python3-dev \
    && pip install -r requirements.txt --no-cache-dir --target /build

FROM python:3.10.4-slim

RUN adduser --system --no-create-home --disabled-password eosantigen

USER eosantigen

WORKDIR /apps/devops-logbook

COPY --from=builder /build/ .

CMD [ "./manage.py", "runserver" ]