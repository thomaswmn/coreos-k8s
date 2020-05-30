#!/bin/bash

cd $(dirname $0)
rootdir=$1
if [ ! -d ../$rootdir ]; then
  echo "root directory $rootdir not found"
  exit 1
fi

docker build ./ -t qcow-image-builder:centos8

origfile=$(readlink ../blob/fedora-coreos-qemu.qcow2.orig)
patchedfile=fedora-coreos-qemu.qcow2.patched

cp ../blob/$origfile ../blob/$patchedfile

docker run --rm -it  \
  -v $(pwd)/../blob:/blob:rw \
  -e LIBGUESTFS_BACKEND=direct \
  qcow-image-builder:centos8 \
  guestfish --rw -a /blob/$patchedfile run : list_filesystems : mount /dev/sda4 / : df : copy-in /$rootdir /ostree/ : df


echo
echo
