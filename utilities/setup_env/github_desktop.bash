#!/bin/bash

TARGET_USER=eosantigen
TARGET_DIR=/home/${TARGET_USER}/Downloads
VERSION="2.9.12"

wget --directory-prefix ${TARGET_DIR} https://github.com/shiftkey/desktop/releases/download/release-${VERSION}-linux4/GitHubDesktop-linux-${VERSION}-linux4.deb

cd ${TARGET_DIR} && dpkg -i GitHubDesktop-linux-${VERSION}-linux4.deb
