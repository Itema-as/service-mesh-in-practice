#!/bin/bash

kubectl delete -f ../resources/server.yaml
kubectl delete -f ../resources/client.yaml

kubectl delete -f ../resources/vs-retry-failure.yaml

kubectl delete -f ../resources/auth-deny-all.yaml
kubectl delete -f ../resources/client-jwt.yaml
kubectl delete -f ../resources/auth-policy-jwt.yaml

kubectl delete -f ../resources/auth-policy-jwt-group.yaml
kubectl delete -f ../resources/client-jwt-group.yaml