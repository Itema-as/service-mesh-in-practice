#!/bin/bash

# Apply Request Authentication rules

# Ask for IP address for KeyCloak (Bridge network adapter)
echo -n "Enter IP address to use: "
read IP_ADDR_BRIDGE

echo ""
echo "### (Istio demo): testing@secure.istio.io"
echo "### (ItemaCon demo): http://localhost:8080/auth/realms/itemacon"
echo -n "Enter JWT Issuer: "
read JWT_ISSUER

echo ""
echo "(Istio demo): https://raw.githubusercontent.com/istio/istio/release-1.9/security/tools/jwt/samples/jwks.json"
echo "(ItemaCon demo): http://${IP_ADDR_BRIDGE}:8080/auth/realms/itemacon/protocol/openid-connect/certs"
echo -n "Enter JWTS Uri: "
read JWTS_URI

echo -n "IP: ${IP_ADDR_BRIDGE}"
echo -n "Issues: ${JWT_ISSUER}"
echo -n "JWTS Uri: ${JWTS_URI}"

kubectl apply -f - <<EOF
apiVersion: "security.istio.io/v1beta1"
kind: "RequestAuthentication"
metadata:
  name: "jwt-example"
  namespace: foo
spec:
  selector:
    matchLabels:
      app: httpbin
  jwtRules:
  - issuer: "${JWT_ISSUER}"
    jwksUri: "${JWTS_URI}"
#    audiences:
#    - energyplan-client
EOF

kubectl describe RequestAuthentication -n foo
