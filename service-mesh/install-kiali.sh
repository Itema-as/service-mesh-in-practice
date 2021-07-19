#!/bin/bash

# Install Kiali and the other addons and wait for them to be deployed.

cd istio/bin
kubectl apply -f ../samples/addons
kubectl rollout status deployment/kiali -n istio-system