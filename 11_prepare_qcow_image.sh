#!/bin/bash
set -e

rootdir=blob/inject

mkdir -p $rootdir
rm -fr $rootdir

# docker and podman images
cp --link --recursive blob/docker-images/images $rootdir/

# TLS certificates
mkdir -p $rootdir/tls/{docker-registry,k8s-api-server}
cp --link tls/docker-registry/ca.crt $rootdir/tls/docker-registry/ca.crt
cp --link --recursive tls/docker-registry/certs/registry $rootdir/tls/docker-registry/
cp --link tls/k8s-api-server/ca.crt $rootdir/tls/k8s-api-server/ca.crt
cp --link --recursive tls/k8s-api-server/certs/apiserver $rootdir/tls/k8s-api-server/

# scripts
cp --link --recursive target-scripts $rootdir/scripts

# k8s deployments
deployments-builder/build-all.sh
cp --link --recursive deployments $rootdir/deployments

# now patch the downloaded qcow image
echo "patching the qcow image with $(du -sh $rootdir) additional data..."
./qcow-image-builder/build-image.sh $rootdir
echo "done."
