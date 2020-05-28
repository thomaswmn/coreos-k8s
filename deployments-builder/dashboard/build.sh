#!/bin/bash
set -e

registry=registry.local:5000
image_dashboard=${registry}/kubernetesui/dashboard:v2.0.1
image_metrics_scraper=${registry}/kubernetesui/metrics-scraper:v1.0.4

cd $(dirname $0)

wget -O - https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.1/aio/deploy/recommended.yaml \
 | sed -re 's#kubernetesui/dashboard:v2.0.1#'$image_dashboard'#' \
 | sed -re 's#kubernetesui/metrics-scraper:v1.0.4#'$image_metrics_scraper'#' \
 | sed -re 's#imagePullPolicy: .*$#imagePullPolicy: Never#' \
 > dashboard.yaml

patch < patch

mv dashboard.yaml ../../deployments/

