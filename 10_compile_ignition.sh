#!/bin/bash

source $(dirname $0)/bin/mo/mo

function dataurl() {
  echo "data:;base64,$(echo "$1" | base64 -w0)"
}

function dataurl_file() {
  echo "data:;base64,$(base64 -w0 $1)"
}

export MO_FAIL_ON_UNSET=true
export CERT_REGISTRY_BOOTSTRAP=$(dataurl_file tls/ca.crt)

cat example.fcc \
  | mo \
  | docker run -i --rm quay.io/coreos/fcct:release --pretty --strict \
  > example.ign
