#!/usr/bin/env bash

echo "===================================="
echo "Configuring Git"
echo "===================================="

USERNAME=$1
EMAIL=$2

if [ -f ~/.gitconfig ]; then
  echo "Git already configured. Skiping..."
  exit 0
fi

git config --global user.name "$USERNAME"
git config --global user.email $EMAIL
