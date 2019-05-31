#!/bin/bash
URL_BIONIC="http://cdimage.ubuntu.com/releases/18.04/release/ubuntu-18.04.2-server-amd64.iso"
FILENAME_BIONIC=$(basename $URL_BIONIC)
echo "Downloading $FILENAME_BIONIC"
test -f ~/$FILENAME_BIONIC || curl $URL_BIONIC -o ~/$FILENAME_BIONIC
test -d /mnt/bionic || sudo mkdir /mnt/bionic
sudo mount -o loop ~/$FILENAME_BIONIC /mnt/bionic

URL_XENIAL="http://releases.ubuntu.com/16.04/ubuntu-16.04.6-server-amd64.iso"
FILENAME_XENIAL=$(basename $URL_XENIAL)
echo "Downloading $FILENAME_XENIAL"
test -f ~/$FILENAME_XENIAL || curl $URL_XENIAL -o ~/$FILENAME_XENIAL
test -d /mnt/xenial ||sudo mkdir /mnt/xenial
sudo mount -o loop ~/$FILENAME_XENIAL /mnt/xenial
