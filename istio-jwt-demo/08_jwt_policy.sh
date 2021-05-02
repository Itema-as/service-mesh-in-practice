#!/bin/bash

# Set require-jwt policy
echo ""
echo "### (Istio demo): testing@secure.istio.io"
echo "### (ItemaCon demo): http://localhost:8080/auth/realms/itemacon"
echo -n "Enter JWT Issuer (iss): "
read KC_ISS

echo ""
echo "### (Istio demo): testing@secure.istio.io"
echo "### (ItemaCon demo): [SOME UUID - LOOK IN TOKEN])"
echo -n "Enter JWT Subject (sub): "
read KC_SUB

REQ_PRINCIPAL=${KC_ISS}/${KC_SUB}
echo ""
echo "Request Principal: ${REQ_PRINCIPAL}"
echo ""

kubectl apply -f - <<EOF
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: require-jwt
  namespace: foo
spec:
  selector:
    matchLabels:
      app: httpbin
  action: ALLOW
  rules:
  - from:
    - source:
       requestPrincipals: [${REQ_PRINCIPAL}]
EOF

kubectl describe AuthorizationPolicy -n foo