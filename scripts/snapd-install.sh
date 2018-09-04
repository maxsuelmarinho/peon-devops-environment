#!/usr/bin/env bash

. /etc/init.d/functions

snapdVersion="2.30-0.el7.centos.1"

echo "===================================="
echo "Installing Snapd"
echo "===================================="

if [ "$(nap --version | awk '/snapd/ {print $2}')" == "$snapdVersion" ]; then
  echo "Snapd already installed. Skiping..."
  success
  exit 0
fi

yum install -y epel-release
yum install -y yum-plugin-copr

yum copr enable ngompa/snapcore-el7 -y

yum install -y snapd

systemctl enable --now snapd.socket

ln -s /var/lib/snapd/snap /snap

snap install heroku --classic

command -v snap > /dev/null 2>&1 || {
    echo
    echo 'Error! Snap is not installed!'
    failure
    echo
    exit 1
}

echo "Snap v$snapdVersion installed."
success
echo
exit 0
