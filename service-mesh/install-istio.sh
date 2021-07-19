#!/bin/bash

# Install istio onto Kubernetes cluster

VERSION_ISTO=1.10.3

curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$VERSION_ISTO sh -
mv istio-$VERSION_ISTO istio
cd istio || exit
export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo -y
kubectl label namespace default istio-injection=enabled
