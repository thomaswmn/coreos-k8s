#!/bin/bash

cd $(dirname $0)

docker build ./ -t imagebuilder:latest

docker run --rm -it  \
  -v $(pwd)/../blob/docker-images/images:/input:ro \
  -v $(pwd)/../blob:/output:rw \
  imagebuilder:latest \
  /sbin/mksquashfs /input /output/images.squashfs -noappend -Xcompression-level 3 -all-root

  # the following saves ~25% of space (but takes much longer)
  #/sbin/mksquashfs /input /output/images.squashfs -noappend -comp xz -Xbcj x86 -all-root

echo
echo
ls -lh ../blob/images.squashfs
