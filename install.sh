#!/bin/bash

JOOL_VERSION='3.5.7'

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Make sure dkms docker and curl are installed
command -v dkms >/dev/null 2>&1 || { echo >&2 "dkms is required but not installed.  Aborting."; exit 1; }
command -v wget >/dev/null 2>&1 || { echo >&2 "wget is required but not installed.  Aborting."; exit 1; }
command -v docker >/dev/null 2>&1 || { echo >&2 "docker is required but not installed.  Aborting."; exit 1; }

echo 'downloading and extracting source...'
(
    wget "https://github.com/NICMx/Jool/archive/v${JOOL_VERSION}.tar.gz" -O "/tmp/jool.tar.gz"
    mkdir /tmp/jool
    tar -xvf /tmp/jool.tar.gz -C /tmp/jool --strip-components=1
    rm -rf "/usr/src/jool-${JOOL_VERSION}"
    mv "/tmp/jool" "/usr/src/jool-${JOOL_VERSION}"
)

echo 'building and installing kernel module...'
(
    dkms add "jool/${JOOL_VERSION}"
    dkms build "jool/${JOOL_VERSION}"
    dkms install "jool/${JOOL_VERSION}"
    modprobe jool
)

echo 'building docker container...'
docker build -t jool-docker:"${JOOL_VERSION}" --build-arg JOOL_VER="${JOOL_VERSION}" .

echo 'clean up...'
(
    rm "/tmp/jool.tar.gz"
    rm -rf "/tmp/jool"
)

echo 'done!'
