#!/bin/bash

kubectl apply -f ../resources/server.yaml
kubectl apply -f ../resources/client.yaml

kubectl apply -f ../resources/vs-retry-failure.yaml

kubectl apply -f ../resources/auth-policy-jwt.yaml
kubectl apply -f ../resources/client-jwt.yaml