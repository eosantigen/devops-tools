#!/bin/bash

LIVINGDAYS=${1-150}
DOCKER_REGISTRY=""
AUTH_HEADER="Authorization: Basic YWRtaW46YWRtaW4="
ACCEPT_HEADER="Accept: application/vnd.docker.distribution.manifest.v2+json"

function get_repositories {
  curl -Ls --header "${AUTH_HEADER}" "${DOCKER_REGISTRY}"/_catalog?n=10000 | jq -r '."repositories"[]'
}

function get_repository_tags {
  curl -Ls --header "${AUTH_HEADER}" "${DOCKER_REGISTRY}"/"$1"/tags/list?n=10000 | jq -r '."tags"[]' | grep "$2" | sort -r | tail -n +6
}

function get_tag_digest {
  REPOSITORY="$1"
  TAG="$2"
  curl -ILs --header "${AUTH_HEADER}" --header "${ACCEPT_HEADER}" "${DOCKER_REGISTRY}"/"${REPOSITORY}"/manifests/"${TAG}" | grep docker-content-digest | awk '{print $2}' | tr -d '\r'
}

REPORITORIES=$(get_repositories)
echo ALL REPOS: ${REPORITORIES}
echo
for REPOSITORY in ${REPORITORIES[@]}
do
  ENVS=("_SNAPSHOT_")
  for env in ${ENVS[@]}
  do
    TAGS=$(get_repository_tags "${REPOSITORY}" "$env")
    echo ${REPOSITORY}: ${TAGS}
    echo
    for TAG in ${TAGS[@]}
    do
      echo ${REPOSITORY}:${TAG}
      DIGEST=$(get_tag_digest "${REPOSITORY}" "${TAG}")
      echo "${DOCKER_REGISTRY}"/"${REPOSITORY}"/manifests/"${DIGEST}"
      URL="${DOCKER_REGISTRY}"/"${REPOSITORY}"/manifests/"${DIGEST}"
      curl --header "${AUTH_HEADER}" -s -X DELETE -i $URL
      echo -------------------------------------------------------------------------------------
      echo
    done
  done
done
