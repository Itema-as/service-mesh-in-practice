# Install Istio

[Installation Guide](https://istio.io/latest/docs/setup/getting-started/#download)

Make sure KeyCloak and Kubernetes is running (Minikube)

```shell
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.9.4 sh -
mv istio-1.9.4 istio
cd istio
export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo -y
kubectl label namespace default istio-injection=enabled
```

_01_install_istio.sh_

## Istio JWT setup demo app

[Authorization with JWT](https://istio.io/latest/docs/tasks/security/authorization/authz-jwt/)

```shell
kubectl create ns foo
kubectl apply -f <(istioctl kube-inject -f samples/httpbin/httpbin.yaml) -n foo
kubectl apply -f <(istioctl kube-inject -f samples/sleep/sleep.yaml) -n foo
```

_02_apply_istio.sh_

Verify sleep can communicate with httpbin

```shell
kubectl exec "$(kubectl get pod -l app=sleep -n foo -o jsonpath={.items..metadata.name})" -c sleep -n foo -- curl http://httpbin.foo:8000/ip -s -o /dev/null -w "%{http_code}\n"
```

_03_verify_sleep.sh_

Set JWT rule (Remember to find the Minikube bridge network address and not localhost :) )

```shell
minikube ip
```

_04_list_ip_addr.sh_

```shell
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
  - issuer: "http://localhost:8080/auth/realms/itemacon"
    jwksUri: "http://192.168.49.1:8080/auth/realms/itemacon/protocol/openid-connect/certs"
    audiences:
    - energyplan-client
EOF
```

_05_apply_request_auth.sh_

Verify request denied with bad JWT

```shell
kubectl exec "$(kubectl get pod -l app=sleep -n foo -o jsonpath={.items..metadata.name})" -c sleep -n foo -- curl "http://httpbin.foo:8000/headers" -s -o /dev/null -H "Authorization: Bearer invalidToken" -w "%{http_code}\n"
```

_06_bad_jwt.sh_

Verify request without JWT is allowed

```shell
kubectl exec "$(kubectl get pod -l app=sleep -n foo -o jsonpath={.items..metadata.name})" -c sleep -n foo -- curl "http://httpbin.foo:8000/headers" -s -o /dev/null -w "%{http_code}\n"
```

_07_no_token.sh_

Set require-jwt policy

```shell
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
       requestPrincipals: ["http://localhost:8080/auth/realms/itemacon/[SOME UUID]]
EOF
```

_08_jwt_policy.sh_

Get a valid token

```shell
TOKEN=eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIxX3hWbWRob01HeEktOWVLcXNrZHhDb0tHRGV3cnp2NTBvN09NaUxHd3cwIn0.eyJleHAiOjE2MDk4NTA3NDcsImlhdCI6MTYwOTg1MDQ0NywianRpIjoiYTc1ZTc1NjgtZDI4YS00YzI3LTk0OGItMzA5ODZmMGM1NjYyIiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL2F1dGgvcmVhbG1zL3NvZ28iLCJhdWQiOlsiZW5lcmd5cGxhbi1jbGllbnQiLCJhY2NvdW50Il0sInN1YiI6IjgxNjFjMjI2LTc5M2EtNDI3Ny04YWJjLTQwMDI3NTk4Mzk5OSIsInR5cCI6IkJlYXJlciIsImF6cCI6ImVuZXJneXBsYW4tY2xpZW50Iiwic2Vzc2lvbl9zdGF0ZSI6ImJmZjYxNDUyLTg3M2YtNDEyMS1iNTZjLTBjODE5Nzk2OWU4NSIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOlsiaHR0cHM6Ly9sb2NhbGhvc3Q6MTEwMDAiXSwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIm9mZmxpbmVfYWNjZXNzIiwidW1hX2F1dGhvcml6YXRpb24iXX0sInJlc291cmNlX2FjY2VzcyI6eyJhY2NvdW50Ijp7InJvbGVzIjpbIm1hbmFnZS1hY2NvdW50Iiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVwYzplcDp3IGVtYWlsIiwiY2xpZW50SG9zdCI6IjE3Mi4yMC4wLjEiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImNsaWVudElkIjoiZW5lcmd5cGxhbi1jbGllbnQiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJzZXJ2aWNlLWFjY291bnQtZW5lcmd5cGxhbi1jbGllbnQiLCJjbGllbnRBZGRyZXNzIjoiMTcyLjIwLjAuMSJ9.FMSZmnvF_47b33YorokNKX9wlOrsQeBIl39Tml-zK42Z3gmIhtSskEEKqkBE6aqMvVJFhh_qMun349eNS8rNf-RM808vmXIZcwqjBJ8trL_z_0aHidiTk_bXwr8HDmutKKX5CjkTcmBaajig5Syi2PAV3EQ_WYaqPzcQNuvFc0DnaorxXdIxtS3T4x_blOiaRhG8MmxTBB3DwGAGVRcW70yyH0ErHxgDOf9lmwSpBYNpZKnPC-emgeW19q-aYozpYCR9NGQhbllSiwnc6-Xr7rZE5TlCG_tfXTdrHnHkSHjmTvxyjl9Gk9RtpT9ssca0ONzIOX7zQ8a_V2ZgoaEACQ
```

Call with token

```shell
kubectl exec "$(kubectl get pod -l app=sleep -n foo -o jsonpath={.items..metadata.name})" -c sleep -n foo -- curl "http://httpbin.foo:8000/headers" -s -H "Authorization: Bearer $TOKEN" -w "\n%{http_code}\n"
```

_09_call_with_token.sh_

Call with no token is denied

```shell
kubectl exec "$(kubectl get pod -l app=sleep -n foo -o jsonpath={.items..metadata.name})" -c sleep -n foo -- curl "http://httpbin.foo:8000/headers" -s -o /dev/null -w "%{http_code}\n"
```

_10_call_no_token.sh_

Clean up namespace when done

```shell
kubectl delete namespace foo
```

_99_cleanup_demo.sh_
