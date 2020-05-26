#!/bin/bash
set -e
K8S_VERSION="v1.18.2"
ETCD_VERSION="v3.3.20"
FLANNEL_VERSION="v0.12.0"

REGISTRY_BOOTSTRAP=registry.bootstrap.local:5000
REGISTRY_MASTER=registry.local:5000


function dockerimg_bootstrap() {
  img=$1
  echo "$REGISTRY_BOOTSTRAP$(echo $img | sed -re 's/[^/]+//')"
}
function dockerimg_master() {
  img=$1
  echo "$REGISTRY_MASTER$(echo $img | sed -re 's/[^/]+//')"
}

odockerimg_hyperkube="gcr.io/google-containers/hyperkube-amd64:${K8S_VERSION}"
odockerimg_flannel="quay.io/coreos/flannel:${FLANNEL_VERSION}-amd64"
odockerimg_etcd="quay.io/coreos/etcd:${ETCD_VERSION}"
odockerimg_pause="k8s.gcr.io/pause-amd64:3.1"
odockerimg_registry="docker.io/registry:latest"
odockerimg_dhcpd="docker.io/networkboot/dhcpd"
odockerimg_tftp="docker.io/jumanjiman/tftp-hpa"
odockerimg_nginx="docker.io/library/nginx"
odockerimg_dashboard="docker.io/kubernetesui/dashboard:v2.0.1"
odockerimg_dashboard_metrics="docker.io/kubernetesui/metrics-scraper:v1.0.4"
odockerimg_alpine="docker.io/alpine:latest"

all_docker_images_o="$odockerimg_hyperkube $odockerimg_flannel $odockerimg_etcd $odockerimg_pause $odockerimg_registry $odockerimg_dashboard $odockerimg_dashboard_metrics $odockerimg_alpine"


mkdir -p blob/docker-images
rm -f blob/docker-images/*

for img in $all_docker_images_o; do
  myimg_m=$(dockerimg_master $img)
  echo "moving $img to $myimg_m"

  docker pull $img 

  docker tag $img $myimg_m

  filename=$(echo $myimg_m | sed -re 's#[/:]#_#g')".tar"
  echo "persisting \"$myimg_m\" to \"$filename\""
  docker save $myimg_m \
    > blob/docker-images/$filename
  chmod 644 blob/docker-images/$filename
done

mkdir -p blob/docker-images/images/{podman,docker}

mv blob/docker-images/registry.local_5000_coreos_etcd* blob/docker-images/images/podman
mv blob/docker-images/registry.local_5000_google-containers_hyperkube* blob/docker-images/images/podman

mv blob/docker-images/registry.local_5000_pause* blob/docker-images/images/docker
mv blob/docker-images/registry.local_5000_registry* blob/docker-images/images/docker
mv blob/docker-images/registry.local_5000_kubernetesui* blob/docker-images/images/docker
mv blob/docker-images/registry.local_5000_alpine* blob/docker-images/images/docker


image-builder/build-image.sh
