# Build image
docker build app/. -t ghcr.io/itema-as/service-mesh-in-practice-server

# Push image
docker push ghcr.io/itema-as/service-mesh-in-practice-server
