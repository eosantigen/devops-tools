FROM python:3.8-alpine3.15

LABEL "Maintainer"="eosantigen" "Project/Dept"="DevOps"

ENV WORKDIR /EOSANTIGEN
# Leave APPDIR below with only its name, no relative path relations.
ENV APPDIR app
ENV PYTHONUNBUFFERED 1
ENV PYTHONPATH $WORKDIR:${APPDIR}

COPY . ${WORKDIR}

WORKDIR ${WORKDIR}

RUN apk --update add build-base && adduser -H -S -D -u 1000 eosantigen && chown -R eosantigen $WORKDIR

USER eosantigen

RUN python -m pip install --no-cache-dir --target=$WORKDIR -r requirements.txt

ENTRYPOINT [ "./check_file_share.py" ]