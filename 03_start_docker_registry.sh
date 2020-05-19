#!/bin/bash
set -e

basedir=$(cd $(dirname $0); pwd)
registrydir=$basedir/blob/docker/registry
certdir=$basedir/tls/certs/bootstrap-registry

mkdir -p $registrydir

docker run \
  --rm \
  -d \
  -p 5000:5000 \
  -v $registrydir:/var/lib/registry \
  -v $certdir:/certs \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/key \
  --name registry \
  registry:latest
