#!/bin/bash

# Get Demo Token
echo ""
echo "####"
echo "Istio DEMO token: "
echo "TOKEN=\$(curl https://raw.githubusercontent.com/istio/istio/release-1.9/security/tools/jwt/samples/demo.jwt -s) && echo "\$TOKEN" && echo "\$TOKEN" | cut -d '.' -f2 - | base64 --decode -"

TOKEN=$(curl https://raw.githubusercontent.com/istio/istio/release-1.9/security/tools/jwt/samples/demo.jwt -s)
echo ""
echo "$TOKEN"
echo ""
echo "$TOKEN" | cut -d '.' -f2 - | base64 --decode -

echo ""
echo "####"