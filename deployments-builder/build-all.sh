#!/bin/bash

cd $(dirname $0)
mkdir -p ../deployments
for script in */build.sh; do
  ./$script
done
