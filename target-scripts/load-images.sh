#!/bin/bash
set -e

for file in /sysroot/ostree/inject/podman/*.xz; do
  cat $file | unxz | podman load
  # also load with docker, to push to registry later
  docker load --input $file
done
for file in /sysroot/ostree/inject/docker/*; do
  docker load --input $file
done
