#!/bin/bash

kubectl delete -f ../resources/server.yaml
kubectl delete -f ../resources/client.yaml

kubectl delete -f ../resources/vs-retry-failure.yaml
