#!/usr/bin/env bash

VERSION=2.2.0
FILE_NAME=dartsdk-linux-x64-release.zip

wget -q https://storage.googleapis.com/dart-archive/channels/stable/release/$VERSION/sdk/$FILE_NAME -O "/tmp/$FILE_NAME" \
    && unzip /tmp/$FILE_NAME -d /tmp/ \
    && mv -v /tmp/dart-sdk /usr/local/bin/dart-sdk-v$VERSION \
    && ln -sf /usr/local/bin/dart-sdk-v$VERSION /usr/local/bin/dart-sdk \
    && rm -rf /tmp/dart*

echo 'export DART_SDK_HOME="/usr/local/bin/dart-sdk"' >> /home/vagrant/.bashrc
echo 'export PATH="\$PATH:\$DART_SDK_HOME/bin"' >> /home/vagrant/.bashrc
