#!/bin/bash

# Install istio onto Kubernetes cluster

if [[ ! -d "istio" ]]
then
    echo "./istio does not exist on your filesystem - downloading"
    VERSION_ISTO=1.11.1

    curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$VERSION_ISTO sh -
    mv istio-$VERSION_ISTO istio
else
    echo "installing istio from ./istio folder"
fi

cd istio || exit
./bin/istioctl install --set profile=demo -y

kubectl label namespace default istio-injection=enabled
