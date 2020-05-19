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
odockerimg_dashboard="k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.1"

all_docker_images_o="$odockerimg_hyperkube $odockerimg_flannel $odockerimg_etcd $odockerimg_pause $odockerimg_registry $odockerimg_dashboard"
docker_images_persist=""

mkdir -p blob/docker-images
rm -f blob/docker-images/*

for img in $all_docker_images_o; do
  myimg=$(dockerimg_bootstrap $img)
  myimg_m=$(dockerimg_master $img)
  echo "moving $img to $myimg and $myimg_m"

  # pull - from local registry if available to save bandwidth
  docker pull $myimg || true
  docker pull $img 

  # re-tag the same image
  docker tag $img $myimg 
  docker tag $img $myimg_m

  # push to bootstrap registry - could be skipped if master registry is always usable
  docker push $myimg  || echo "can not push $myimg"

  #docker_images_persist="$docker_images_persist $myimg_m"
  filename=$(echo $myimg_m | sed -re 's#[/:]#_#g')".tar.gz"
  echo "persisting \"$myimg_m\" to \"$filename\""
  docker save $myimg_m \
    | gzip --fast \
    > blob/docker-images/$filename
    #| xz -T0 --compress --stdout -1 \
  chmod 644 blob/docker-images/$filename
done


#echo "persisting docker images..."
#mkdir -p blob/docker-images
#rm -f blob/docker-images/*
#docker save $docker_images_persist | \
#  xz -T0 --compress --stdout -1 \
#  > blob/docker-images/images.tar.xz
#chmod 644 blob/docker-images/images.tar.xz
#echo "done."

#echo "persisting rkt images..."
#for img in $rkt_images_persist; do
#  echo rkt image fetch --insecure-options=image,http docker://$img
#  rkt image fetch --insecure-options=image,http docker://$img || echo "failed to fetch rkt image - continue with existing images"
#  echo rkt image export $(dockerimg_rkt $img) ${blobdir}/http/docker/$(dockerimg_aci $img)
#  rkt image export --overwrite $(dockerimg_rkt $img) ${blobdir}/http/docker/$(dockerimg_aci $img).tmp && \
#    xz -T0 -7 ${blobdir}/http/docker/$(dockerimg_aci $img).tmp && \
#    mv ${blobdir}/http/docker/$(dockerimg_aci $img).tmp.xz ${blobdir}/http/docker/$(dockerimg_aci $img)
#done
#echo "done."

#for img in $all_docker_images_o; do
#  myimg=$(dockerimg_bootstrap $img)
#  docker image rm $img || true
#  docker image rm $myimg || true
#done
