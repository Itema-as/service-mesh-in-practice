#!/bin/bash

# Install istio onto Kubernetes cluster

curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.9.4 sh -
mv istio-1.9.4 istio
cd istio || exit
export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo -y
kubectl label namespace default istio-injection=enabled
