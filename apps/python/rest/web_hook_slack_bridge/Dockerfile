FROM python:3.8-alpine3.15

LABEL "Maintainer"="eosantigen"

ENV WORKDIR /EOSANTIGEN
# Leave APPDIR below with only its name, no relative path relations.
ENV APPDIR app
ENV PYTHONUNBUFFERED 1
ENV PYTHONPATH $WORKDIR:${APPDIR} 

COPY . ${WORKDIR}

WORKDIR ${WORKDIR}

RUN apk --update add build-base && adduser -H -S -D -u 1000 eosantigen && chown -R eosantigen $WORKDIR

USER metis

RUN python -m pip install --no-cache-dir --target=$WORKDIR -r requirements.txt

EXPOSE 8000

ENTRYPOINT [ "./bin/uvicorn", "--host", "0.0.0.0", "--port", "8000", "--log-level", "error", "--app-dir", "app", "web_hook_slack_bridge:serve" ]