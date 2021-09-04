#!/bin/bash

kubectl delete -f ../resources/server.yaml
kubectl delete -f ../resources/client.yaml

kubectl delete -f ../resources/vs-retry-failure.yaml

kubectl delete -f ../resources/service-account.yaml
kubectl delete -f ../resources/auth-deny-all.yaml
kubectl delete -f ../resources/auth-policy-sa.yaml
kubectl delete -f ../resources/client-sa.yaml
