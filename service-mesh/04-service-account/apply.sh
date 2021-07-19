kubectl apply -f ../resources/server.yaml
kubectl apply -f ../resources/client.yaml

kubectl apply -f ../resources/vs-retry-failure.yaml

kubectl apply -f ../resources/auth-policy-sa.yaml

read -n 1 -s -r -p "Press any key to continue"
echo ""

kubectl apply -f ../resources/client-sa.yaml
