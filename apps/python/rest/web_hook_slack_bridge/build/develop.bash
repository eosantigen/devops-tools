#!/usr/bin/env bash

set -e

ENV="develop"
DEVELOP_DOCKER_REPOSITORY=""
APP_NAME="web-hook-slack-bridge"
DEPLOY_DIR="../deploy"

docker build -t ${DEVELOP_DOCKER_REPOSITORY}/${APP_NAME} -f ../Dockerfile ../
docker push ${DEVELOP_DOCKER_REPOSITORY}/${APP_NAME}

if [[ -d ${DEPLOY_DIR} ]] || [[ -s ${DEPLOY_DIR}/${ENV}.yaml ]]; then
    sed -i -e "s/{APP_NAME}/${APP_NAME}/g" ${DEPLOY_DIR}/${ENV}.yaml
    sed -i -e "s/{DEVELOP_DOCKER_REPOSITORY}/${DEVELOP_DOCKER_REPOSITORY}/g" ${DEPLOY_DIR}/${ENV}.yaml
else
  echo -e "DEPLOY DIRECTORY - OR FILE IN IT - DOES NOT EXIST.\n"
fi