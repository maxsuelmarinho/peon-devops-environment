#!/usr/bin/env bash

NGROK_VERSION="2.2.8"
NGROK_FILE="ngrok-stable-linux-amd64.zip"

echo "===================================="
echo "Installing NGrok"
echo "===================================="

if [ "$(/usr/local/bin/ngrok version 2>&1 | awk '/ngrok version/ {print $3}' | egrep -o '[^\,v"]*')" == "$NGROK_VERSION" ]; then
  echo "NGrok already installed. Skiping..."
  exit 0
fi

echo "Configuring NGrok..."
wget -q https://bin.equinox.io/c/4VmDzA7iaHb/${NGROK_FILE} -O "/tmp/${NGROK_FILE}" \
  && unzip /tmp/${NGROK_FILE} -d /tmp/ \
  && cd /tmp/ \
  && mv -v /tmp/ngrok /usr/local/bin/ \
  && rm -rf /tmp/ngrok*

echo "NGrok configured."

/usr/local/bin/ngrok version
