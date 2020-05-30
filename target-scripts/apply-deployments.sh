#!/bin/bash
set -e
export KUBERNETES_MASTER=http://127.0.0.1:8080
kubectl apply -f /sysroot/ostree/inject/deployments
