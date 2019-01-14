#!/usr/bin/env bash

echo "===================================="
echo "Installing Minikube"
echo "===================================="

VERSION=0.32.0
SO=linux
if [ ! -z "$1" ]; then
  SO="$1"
fi
DESTINATION=/usr/local/bin/
if [ ! -z "$2" ]; then
  DESTINATION="$2"
fi

if [ "$(minikube version 2>&1 | awk '/version/ {print $3}' | egrep -o '[^\"v]*')" == $VERSION ]; then
  echo "Minikube already installed. Skiping..."
  exit 0
fi

cd /tmp/
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v${VERSION}/minikube-${SO}-amd64 \
    && chmod +x minikube \
    && sudo mv minikube $DESTINATION
