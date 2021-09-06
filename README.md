# service-mesh-in-practice

K8s service mesh examples and demos

## Kubernetes

Any kubernetes cluster with a configured kubectl can be used for these exercises, but we will use Minikube

### Starting Minikube

    minikube start --memory=8192 --cpus=4

Istio wants some more resources to be available than the defult, so you might need to go into your docker engine settings and adjust CPU and memory allocation

### Cleanup Minikube

After minikube usage is done, it should be stopped

    minikube stop

Or deleted

    minikube delete

## Installing Istio

Run the provided util scripts for installing Istio and Kiali

    ./install-istio.sh
    ./install-kiali.sh

To launch the kiali dashboard, run the followingn in a separate terminal

    ./launch-kiali.sh

## Run the Exercises

change directory into the `service-mesh/xx-NAME` frolders

**Applying the configurations**

    ./apply.sh

**Deleting the configurations**

    ./delete.sh

## Debug with Curl Container

Apply the curl container into the cluster

    kubectl apply -f service-mesh/resources/sleep-curl-tool.yaml

Try runnig CURL from inside the container

**Basic CURL**

    kubectl exec "$(kubectl get pod -l app=sleep -o jsonpath={.items..metadata.name})" -c sleep -- curl -i http://itemacon-server-service.default.svc.cluster.local:8080/resource  -sS -o /dev/null -w "%{http_code}\n"

**CURL With JWT**

Get the test Token

    TOKEN=$(curl https://raw.githubusercontent.com/istio/istio/release-1.11/security/tools/jwt/samples/demo.jwt -s) && echo "$TOKEN" | cut -d '.' -f2 - | base64 --decode -

Call with Token

    kubectl exec "$(kubectl get pod -l app=sleep -o jsonpath={.items..metadata.name})" -c sleep -- curl -i http://itemacon-server-service.default.svc.cluster.local:8080/resource  -sS -o /dev/null -H "Authorization: Bearer $TOKEN" -w "%{http_code}\n"

**CURL with JWT-Group**

    TOKEN_GROUP=$(curl https://raw.githubusercontent.com/istio/istio/release-1.11/security/tools/jwt/samples/groups-scope.jwt -s) && echo "$TOKEN_GROUP" | cut -d '.' -f2 - | base64 --decode -

Call with Group token

    kubectl exec "$(kubectl get pod -l app=sleep -o jsonpath={.items..metadata.name})" -c sleep -- curl -i http://itemacon-server-service.default.svc.cluster.local:8080/resource  -sS -o /dev/null -H "Authorization: Bearer $TOKEN_GROUP" -w "%{http_code}\n"
