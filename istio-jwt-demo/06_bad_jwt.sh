#!/bin/bash

# Verify request denied with bad JWT

echo 'Expected output when pods are running: 401'

kubectl exec "$(kubectl get pod -l app=sleep -n foo -o jsonpath={.items..metadata.name})" \
-c sleep -n foo -- curl "http://httpbin.foo:8000/headers" -s -o /dev/null -H "Authorization: Bearer invalidToken" \
-w "%{http_code}\n"
