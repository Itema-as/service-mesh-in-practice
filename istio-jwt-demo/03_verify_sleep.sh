#!/bin/bash

# Verify sleep can communicate with httpbin

echo 'Expected output when pods are running: 200'

kubectl exec "$(kubectl get pod -l app=sleep -n foo -o jsonpath={.items..metadata.name})" \
-c sleep -n foo -- curl http://httpbin.foo:8000/ip -s -o /dev/null -w "%{http_code}\n"
