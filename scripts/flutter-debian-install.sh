#!/usr/bin/env bash

echo "===================================="
echo "Installing Flutter"
echo "===================================="

sudo apt-get update -y \
&& sudo apt-get install -y bash curl git unzip xz-utils

cd /tmp \
  && curl -LO https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.0.0-stable.tar.xz \
  && tar -xvf flutter_linux_v1.0.0-stable.tar.xz \
  && mv -f flutter ~/ \
  && echo 'export PATH="$PATH:~/flutter/bin"' >> ~/.bashrc

flutter doctor
