#!/bin/bash

source $(dirname $0)/bin/mo/mo

function dataurl() {
  echo "data:;base64,$(echo "$1" | base64 -w0)"
}

function dataurl_file() {
  echo "data:;base64,$(base64 -w0 $1)"
}


export MO_FAIL_ON_UNSET=true
export CA_REGISTRY=$(dataurl_file tls/ca.crt)
export SERVICEACCOUNT_KEY_PRIVATE=$(dataurl_file tls/k8s-service-accounts/private_unencrypted.pem)
export SERVICEACCOUNT_KEY_PUBLIC=$(dataurl_file tls/k8s-service-accounts/public.pem)
export K8S_CA_CRT=$(dataurl_file tls/k8s-api-server/ca.crt)
export K8S_APISERVER_CRT=$(dataurl_file tls/k8s-api-server/certs/apiserver/crt)
export K8S_APISERVER_KEY=$(dataurl_file tls/k8s-api-server/certs/apiserver/key)

# tar.xz created from the deployments directory
deployments-builder/build-all.sh
export K8S_DEPLOYMENTS_TAR_XZ="data:;base64,"$(tar -cJf - -C deployments/ ./ | base64 -w0)

cat example.fcc \
  | mo \
  | docker run -i --rm quay.io/coreos/fcct:release --pretty --strict \
  > example.ign
