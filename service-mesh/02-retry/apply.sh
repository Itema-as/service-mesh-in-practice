#!/bin/bash

kubectl apply -f ../resources/server.yaml
kubectl apply -f ../resources/client.yaml

kubectl apply -f ../resources/vs-retry.yaml