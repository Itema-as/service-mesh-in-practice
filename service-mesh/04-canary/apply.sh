#!/bin/bash

kubectl apply -f ../resources/server.yaml
kubectl apply -f ../resources/client.yaml

kubectl apply -f ../resources/vs-retry-canary.yaml
kubectl apply -f ../resources/server_v2.yaml