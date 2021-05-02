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

echo ""
echo "### (Istio demo): request.auth.claims[groups]"
echo "### (ItemaCon demo): TODO!)"
echo -n "Enter JWT Groups Claim Key: "
read KC_CLAIM_KEY

echo ""
echo '### (Istio demo): ["group1"]'
echo "### (ItemaCon demo): TODO!)"
echo -n "Enter JWT Groups Claim Value: "
read KC_CLAIM_VALUE

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
    when:
    - key: ${KC_CLAIM_KEY}
      values: ${KC_CLAIM_VALUE}
EOF

kubectl describe AuthorizationPolicy -n foo