#!/bin/bash
set -e
docker image ls | grep -v REPOSITORY | while read image tag others ; do
  docker push $image:$tag
done
