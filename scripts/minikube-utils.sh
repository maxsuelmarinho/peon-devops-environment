#!/usr/bin/env bash

setMinikube() {
        export DOCKER_TLS_VERIFY="1"
        export DOCKER_HOST="tcp://192.168.99.100:2376"
        export DOCKER_CERT_PATH="/home/vagrant/minikube-certs"
        export DOCKER_API_VERSION="1.35"
        echo "Minikube environment variables configured."
}

unsetMinikube() {
        unset DOCKER_HOST
        unset DOCKER_CERT_PATH
        unset DOCKER_TLS_VERIFY
        unset DOCKER_API_VERSION
        echo "Minikube environment variables removed."
}
