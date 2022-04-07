#!/usr/bin/env bash

# Installs nodejs from the Linux binary package
# ~/bin/node ...etc...
# RTFM : https://github.com/nodejs/help/wiki/Installation


BIN_DIR=$HOME/bin

check_bin_dir() {
  [ -d ${BIN_DIR} ]
}

# LINUX
install_on_linux() {

  echo $VERSION

  VERSION_URL__LINUX="https://nodejs.org/dist/v${VERSION}/node-v${VERSION}-linux-x64.tar.xz"

  wget -c --directory-prefix ${BIN_DIR} ${VERSION_URL__LINUX} --show-progress
  tar -xvf ${BIN_DIR}/node-v${VERSION}-linux-x64.tar.xz -C ${BIN_DIR}
  ln -s ${BIN_DIR}/node-v${VERSION}-linux-x64/bin/node ${BIN_DIR}/node-${VERSION}
  rm ${BIN_DIR}/node-v${VERSION}-linux-x64.tar.xz

  echo "DONE. BYE."

}

# FREEBSD
install_on_freebsd() {

  VERSION_URL__FREEBSD="https://nodejs.org/dist/v16.14.2/node-v16.14.2-darwin-arm64.tar.gz"
  return

}

# MACOS (aka DARWIN)
install_on_macos() {
  VERSION_URL__MACOS="https://nodejs.org/dist/v16.14.2/node-v16.14.2-darwin-arm64.tar.gz"
  return
}


check_platform_and_fetch_package() {

  [[ $(uname -a | grep Linux) ]]
  check_platform__linux=$?

  if [[ check_platform__linux -eq 0 ]]; then
    install_on_linux
  fi

  [[ $(uname -a | grep FreeBSD) ]]
  check_platform__freebsd=$?
  
  if [[ check_platform__freebsd -eq 0 ]]; then
    PLATFORM="FreeBSD"
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
