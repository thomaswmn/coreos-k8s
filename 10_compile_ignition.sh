#!/bin/bash

#source $(dirname $0)/bin/mo/mo

#function dataurl() {
#  echo "data:;base64,$(echo "$1" | base64 -w0)"
#}

#function dataurl_file() {
#  echo "data:;base64,$(base64 -w0 $1)"
#}


#export MO_FAIL_ON_UNSET=true
#cat example.fcc \
#  | mo \
#  | docker run -i --rm quay.io/coreos/fcct:release --strict \
#  > example.ign

scripts="master worker"

for script in $scripts; do
  cat $script.fcc \
    | docker run -i --rm quay.io/coreos/fcct:release --strict \
    > $script.ign
done


for script in $scripts; do
  echo "size of final script $script.ign is $(wc -c $script.ign | cut -d' ' -f1) bytes"
done

