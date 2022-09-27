#!/usr/bin/env bash

set -e

ENV="production"
PRODUCTION_DOCKER_REPOSITORY=""
APP_NAME="web-hook-slack-bridge"
DEPLOY_DIR="../deploy"

docker build -t ${PRODUCTION_DOCKER_REPOSITORY}/${APP_NAME} -f ../Dockerfile ../
docker push ${PRODUCTION_DOCKER_REPOSITORY}/${APP_NAME}

if [[ -d ${DEPLOY_DIR} ]] || [[ -s ${DEPLOY_DIR}/${ENV}.yaml ]]; then
    sed -i -e "s/{APP_NAME}/${APP_NAME}/g" ${DEPLOY_DIR}/${ENV}.yaml
    sed -i -e "s/{PRODUCTION_DOCKER_REPOSITORY}/${PRODUCTION_DOCKER_REPOSITORY}/g" ${DEPLOY_DIR}/${ENV}.yaml
else
  echo -e "DEPLOY DIRECTORY - OR FILE IN IT - DOES NOT EXIST.\n"
fi