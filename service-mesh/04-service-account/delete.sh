kubectl apply -f ../resources/server.yaml
kubectl apply -f ../resources/simple-client.yaml

kubectl apply -f ../resources/vs-retry-failure.yaml

kubectl apply -f ../resources/auth-policy-sa.yaml
kubectl apply -f ../resources/simple-client-sa.yaml
