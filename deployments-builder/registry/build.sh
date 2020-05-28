#!/bin/bash
set -e


cd $(dirname $0)

export MO_FAIL_ON_UNSET=true
export REGISTRY_TLS_KEY=$(base64 -w0 ../../tls/certs/registry/key)
export REGISTRY_TLS_CERT=$(base64 -w0 ../../tls/certs/registry/crt)

cat registry.yaml \
  | ../../bin/mo/mo \
  > ../../deployments/registry.yaml
