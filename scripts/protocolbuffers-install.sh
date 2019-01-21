#!/usr/bin/env bash

echo "===================================="
echo "Installing Protocol Buffers"
echo "===================================="

VERSION=3.6.1

if [ "$(protoc --version 2>&1 | awk '/libprotoc/ {print $2}' | egrep -o '[^\"]{5}')" == "$VERSION" ]; then
  echo "Protocol Buffers already installed. Skiping..."
  exit 0
fi

cd /tmp \
  && curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v$VERSION/protoc-$VERSION-linux-x86_64.zip \
  && unzip protoc-$VERSION-linux-x86_64.zip -d protoc-$VERSION-linux-x86_64 \
  && mv -f protoc-$VERSION-linux-x86_64 ~/ \
  && echo "export PATH=\"\$PATH:~/protoc-$VERSION-linux-x86_64/bin\"" >> ~/.bashrc
