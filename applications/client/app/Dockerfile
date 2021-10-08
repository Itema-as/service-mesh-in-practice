FROM golang:alpine as build-env

# Install necessary
RUN apk add --update --no-cache \
    git \
    gcc \
    ca-certificates && \
    update-ca-certificates

# Create appuser
ENV USER=appuser
ENV UID=10001

# See https://stackoverflow.com/a/55757473/12429735RUN
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"

# Create workdir
WORKDIR /app

# COPY the source code as the last step
COPY . .

# Build the binary
RUN CGO_ENABLED=0 go build -o /app/app client.go

# https://medium.com/@chemidy/create-the-smallest-and-secured-golang-docker-image-based-on-scratch-4752223b7324
# ############### RUNTIME
FROM scratch

###########################################################################################
LABEL dev.azure.com.sogodigital.maintainer="John A. Fossum <john.fossum@itema.no>"  \
    dev.azure.com.sogodigital.description="Runtime image for GO service"  \
    org.opencontainers.image.source="https://github.com/Itema-as/service-mesh-in-practice"
###########################################################################################

# Copy generic resources from build
COPY --from=build-env /etc/ssl/certs/* /etc/ssl/certs/
COPY --from=build-env /etc/passwd /etc/passwd
COPY --from=build-env /etc/group /etc/group

# Copy from builder-env
COPY --from=build-env /app/app app

# Use an unprivileged user.
USER appuser:appuser

# Set entrypoint
ENTRYPOINT ["./app"]