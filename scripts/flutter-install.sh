#!/usr/bin/env bash

VERSION=1.2.1
FILE_NAME=flutter_linux_v$VERSION-stable.tar.xz

sudo yum update -y
sudo yum install -y \
    bash \
    curl \
    git \
    unzip \
    xz-utils

wget -q https://storage.googleapis.com/flutter_infra/releases/stable/linux/$FILE_NAME -O "/tmp/$FILE_NAME" \
    && cd /tmp \
    && tar -xvf $FILE_NAME \
    && mv -v /tmp/flutter /usr/local/bin/flutter-v$VERSION \
    && ln -sf /usr/local/bin/flutter-v$VERSION /usr/local/bin/flutter \
    && rm -rf /tmp/flutter*

echo 'export FLUTTER_HOME="/usr/local/bin/flutter"' >> /home/vagrant/.bashrc
echo 'export PATH="\$PATH:\$FLUTTER_HOME/bin"' >> /home/vagrant/.bashrc

source /home/vagrant/.bashrc

flutter doctor
flutter doctor --android-licenses
