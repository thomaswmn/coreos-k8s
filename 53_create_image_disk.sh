#!/bin/bash

#-rw-r--r-- 1 thomas thomas  18M 11. Mai 14:40 registry.local_coreos_etcd_v3.3.20.tar.gz
#-rw-r--r-- 1 thomas thomas  19M 11. Mai 14:39 registry.local_coreos_flannel_v0.12.0-amd64.tar.gz
#-rw-r--r-- 1 thomas thomas 284M 11. Mai 14:38 registry.local_google-containers_hyperkube-amd64_v1.18.2.tar.gz
#-rw-r--r-- 1 thomas thomas  47M 11. Mai 14:40 registry.local_kubernetes-dashboard-amd64_v1.10.1.tar.gz
#-rw-r--r-- 1 thomas thomas 334K 11. Mai 14:40 registry.local_pause-amd64_3.1.tar.gz
#-rw-r--r-- 1 thomas thomas  11M 11. Mai 14:40 registry.local_registry_latest.tar.gz


# 1GB sparse file
rm -f images.img
dd if=/dev/null of=images.img bs=1M seek=1024

mkfs.ext4 -L images -F images.img
mkdir ./images

sudo mount -t ext4 -o loop images.img ./images
sudo mkdir -p ./images/docker
sudo mkdir -p ./images/podman
sudo cp blob/docker-images/registry.local_5000_coreos_etcd* ./images/podman
sudo cp blob/docker-images/registry.local_5000_google-containers_hyperkube* ./images/podman
sudo cp blob/docker-images/registry.local_5000_pause* ./images/docker
sudo cp blob/docker-images/registry.local_5000_registry* ./images/docker
sudo cp blob/docker-images/registry.local_5000_kubernetes-dashboard* ./images/docker
sudo cp blob/docker-images/registry.local_5000_kubernetesui* ./images/docker
sudo cp blob/docker-images/registry.local_5000_alpine* ./images/docker
find ./images/ -ls
sudo umount images

rmdir ./images



