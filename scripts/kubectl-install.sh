#!/usr/bin/env bash

echo "===================================="
echo "Installing Kubectl"
echo "===================================="

SO=linux
if [ ! -z "$1" ]; then
  SO="$1"
fi

DESTINATION=/usr/local/bin/kubectl
if [ ! -z "$2" ]; then
  DESTINATION="$2"
fi

VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
if [ "$(kubectl version 2>&1 | awk '/version/ {print $5}' | egrep -o '[^\"GitVersion:,]*')" == $VERSION ]; then
  echo "Kubectl already installed. Skiping..."
  exit 0
fi

cd /tmp/ \
  && curl -LO https://storage.googleapis.com/kubernetes-release/release/${VERSION}/bin/${SO}/amd64/kubectl \
  && chmod +x ./kubectl \
  && mv ./kubectl $DESTINATION
