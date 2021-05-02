#!/bin/bash

# Get Demo Token
echo ""
echo "####"
echo "Istio Demo SCOPE token: "
echo "TOKEN_GROUP=\$(curl https://raw.githubusercontent.com/istio/istio/release-1.9/security/tools/jwt/samples/groups-scope.jwt -s) && echo "\$TOKEN_GROUP" && echo "\$TOKEN_GROUP" | cut -d '.' -f2 - | base64 --decode -"

TOKEN_GROUP=$(curl https://raw.githubusercontent.com/istio/istio/release-1.9/security/tools/jwt/samples/groups-scope.jwt -s)
echo ""
echo "$TOKEN_GROUP"
echo ""
echo "$TOKEN_GROUP" | cut -d '.' -f2 - | base64 --decode -

echo ""
echo "####"