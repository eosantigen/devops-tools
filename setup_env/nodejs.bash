#!/usr/bin/env bash

# Installs nodejs from the binary package
# RTFM : https://github.com/nodejs/help/wiki/Installation


BIN_DIR=$HOME/bin

# LINUX
install_on_linux() {

  echo $VERSION

  VERSION_URL__LINUX="https://nodejs.org/dist/v${VERSION}/node-v${VERSION}-linux-x64.tar.xz"

  wget -c --directory-prefix ${BIN_DIR} ${VERSION_URL__LINUX} --show-progress
  tar -xvf ${BIN_DIR}/node-v${VERSION}-linux-x64.tar.xz -C 	${BIN_DIR}
  ln -s ${BIN_DIR}/node-v${VERSION}-linux-x64/bin/node		${BIN_DIR}/node
  ln -s ${BIN_DIR}/node-v${VERSION}-linux-x64/bin/npm 		${BIN_DIR}/npm
  ln -s ${BIN_DIR}/node-v${VERSION}-linux-x64/bin/npx 		${BIN_DIR}/npx
  rm ${BIN_DIR}/node-v${VERSION}-linux-x64.tar.xz

  echo "DONE. BYE."

}

# MACOS (aka DARWIN)
install_on_macos() {

  echo $VERSION

  VERSION_URL__MACOS="https://nodejs.org/dist/v${VERSION}/node-v${VERSION}-darwin-arm64.tar.gz"

  wget -c --directory-prefix ${BIN_DIR} ${VERSION_URL__MACOS} --show-progress
  tar -xvf ${BIN_DIR}/node-v${VERSION}-darwin-arm64.tar.gz -C 	${BIN_DIR}
  ln -s ${BIN_DIR}/node-v${VERSION}-darwin-arm64/bin/node 	${BIN_DIR}/node
  ln -s ${BIN_DIR}/node-v${VERSION}-darwin-arm64/bin/npm 	${BIN_DIR}/npm
  ln -s ${BIN_DIR}/node-v${VERSION}-darwin-arm64/bin/npx 	${BIN_DIR}/npx
  rm ${BIN_DIR}/node-v${VERSION}-darwin-arm64.tar.gz

  echo "DONE. BYE."
}


check_platform_and_fetch_package() {

  [[ $(uname -a | grep Linux) ]]
  check_platform__linux=$?

  if [[ check_platform__linux -eq 0 ]]; then
    install_on_linux
  fi

  [[ $(uname -a | grep Darwin) ]]
  check_platform__macos=$?

  if [[ check_platform__macos -eq 0 ]]; then
    install_on_macos
  fi
}


if [[ $1 == "" ]]; then
  echo "Requires an option: -v <Nodejs version> (please prefer LTS...)"
  exit 1
else
  while getopts "v:" option; do
    case ${option} in
      v )
        read -p "Nodejs version has been set to : [${OPTARG}] - [y/n] ? [Default: n]: "
            REPLY=${REPLY:-n}

            if [ ${REPLY} == "n" ]; then
              echo "CANCELLED. BYE."
              exit 1
            elif [ ${REPLY} == "y" ]; then
              VERSION=${OPTARG}
              check_platform_and_fetch_package
            fi
          ;;
      * )
          exit 1
        esac
    done
fi
