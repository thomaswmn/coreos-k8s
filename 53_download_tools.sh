#!/bin/bash
set -e

cd $(dirname $0)
mkdir -p bin/mo
curl -sSL https://git.io/get-mo -o bin/mo/mo
chmod +x bin/mo/mo
