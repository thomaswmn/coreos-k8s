#!/bin/bash
#set -x
set -e

mkdir -p $(dirname $0)/blob
cd $(dirname $0)/blob

wget https://builds.coreos.fedoraproject.org/streams/stable.json
url=$(cat stable.json | jq --raw-output '.architectures.x86_64.artifacts.qemu.formats."qcow2.xz".disk.location')
checksum_should=$(cat stable.json | jq --raw-output '.architectures.x86_64.artifacts.qemu.formats."qcow2.xz".disk.sha256')
rm stable.json

test -f $(basename $url) || wget $url 
checksum_is=$(sha256sum $(basename $url) | cut -d" " -f1)

if [ "$checksum_is" == "$checksum_should" ]; then
  echo "checksum OK"
else
  echo "checksum failure"
  exit 1
fi



unxz $(basename $url)
rm -f fedora-coreos-qemu.qcow2.orig
ln -s $(basename $url .xz) fedora-coreos-qemu.qcow2.orig
