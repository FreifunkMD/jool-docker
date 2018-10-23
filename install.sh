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

echo 'downloading source...'
wget "https://github.com/NICMx/releases/raw/master/Jool/Jool-${JOOL_VERSION}.zip" -O "/tmp/Jool-${JOOL_VERSION}.zip"

echo 'extracting...'
(
    unzip -d /tmp "/tmp/Jool-${JOOL_VERSION}.zip"
    mv "/tmp/Jool-${JOOL_VERSION}/" "/usr/src/jool-${JOOL_VERSION}"
)
echo 'creating dkms config file...'
(
    cat << EOF > "/usr/src/jool-${JOOL_VERSION}/dkms.conf"
PACKAGE_NAME="jool"
PACKAGE_VERSION="${JOOL_VERSION}"
BUILT_MODULE_NAME[0]="jool"
DEST_MODULE_LOCATION[0]="/kernel/drivers/misc"
AUTOINSTALL="yes"
EOF
)
echo 'building and installing kernel module...'
(
    rm -rf "/usr/src/jool-${JOOL_VERSION}"
    dkms add "jool/${JOOL_VERSION}"
    dkms build "jool/${JOOL_VERSION}"
    dkms install "jool/${JOOL_VERSION}"
    modprobe jool
)
echo 'building docker container...'
docker build -t jool-docker:"${JOOL_VERSION}" --build-arg JOOL_VER="${JOOL_VERSION}" .

echo 'clean up...'
(
    rm "/tmp/Jool-${JOOL_VERSION}.zip"
    rm -rf "/tmp/Jool-${JOOL_VERSION}"
)
echo 'done!'
