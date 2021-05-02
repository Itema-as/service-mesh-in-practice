#!/bin/bash

./80_istio_demo_token.sh
./81_istio_scope_demo_token.sh

# Ask for Token to use
echo ""
echo ""
echo -n "Enter JWT with Group: "
read JWT_TOKEN_GROUP

echo ""
echo 'Expected output when pods are running: 200'
echo ""

kubectl exec "$(kubectl get pod -l app=sleep -n foo -o jsonpath={.items..metadata.name})" \
-c sleep -n foo -- curl "http://httpbin.foo:8000/headers" -s -H "Authorization: Bearer $JWT_TOKEN_GROUP" -w "\n%{http_code}\n"


# Ask for Token to use
echo ""
echo ""
echo -n "Enter JWT with NO Group: "
read JWT_TOKEN

echo ""
echo 'Expected output when pods are running: 403'
echo ""

kubectl exec "$(kubectl get pod -l app=sleep -n foo -o jsonpath={.items..metadata.name})" \
-c sleep -n foo -- curl "http://httpbin.foo:8000/headers" -s -H "Authorization: Bearer $JWT_TOKEN" -w "\n%{http_code}\n"
