#!/bin/bash

cd $(dirname $0)
for script in */build.sh; do
  ./$script
done
