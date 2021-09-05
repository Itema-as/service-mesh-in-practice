#!/bin/bash

VERSION_ISTO=1.11.1

curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$VERSION_ISTO sh -
mv istio-$VERSION_ISTO istio
