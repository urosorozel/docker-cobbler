#!/bin/bash
URL="http://cdimage.ubuntu.com/releases/18.04/release/ubuntu-18.04.4-server-amd64.iso"
COBBLER_SHARE_PATH="/mnt2/pool/cobbler"
DISTRO_NAME="ubuntu-18.04.4-server"
FILENAME=$(basename $URL)
echo "Downloading $FILENAME"
test -f ~/$FILENAME || curl $URL -o ~/$FILENAME
test -d ${COBBLER_SHARE_PATH}/iso/${DIR} || mkdir ${COBBLER_SHARE_PATH}/iso/${DISTRO_NAME}
mount -o loop ~/$FILENAME ${COBBLER_SHARE_PATH}/iso/${DIR}
