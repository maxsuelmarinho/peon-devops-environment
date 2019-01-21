#!/usr/bin/env bash

echo "===================================="
echo "Installing Dart"
echo "===================================="

VERSION="2.1.0"

if [ "$(dart --version 2>&1 | awk '/version:/ {print $4}' | egrep -o '[^\"]{5}')" == "$VERSION" ]; then
  echo "Dart already installed. Skiping..."
  exit 0
fi

sudo apt-get update -y
sudo apt-get install -y apt-transport-https
sudo sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
sudo sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'

sudo apt-get update -y
sudo apt-get install -y dart

echo 'export PATH="$PATH:/usr/lib/dart/bin"' >> ~/.bashrc
