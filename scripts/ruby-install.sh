#!/usr/bin/env bash

. /etc/init.d/functions

rubyVersion=$1

echo "===================================="
echo "Installing Ruby"
echo "===================================="

if [ "$(ruby -v 2>&1 | awk '/ruby/ {print $2}' | egrep -o '[^\"]{5}')" == "$rubyVersion" ]; then
  echo "Ruby already installed. Skiping..."
  success
  exit 0
fi

sudo yum install -y gcc-c++ patch readline readline-devel zlib zlib-devel \
                    libyaml-devel libffi-devel openssl-devel make \
                    bzip2 autoconf automake libtool bison curl sqlite-devel

curl -sSL https://rvm.io/mpapis.asc | sudo gpg2 --import -
curl -sSL https://rvm.io/pkuczynski.asc | sudo gpg2 --import -
curl -sSL https://get.rvm.io | sudo bash -s stable

usermod -a -G rvm `whoami`

source /etc/profile.d/rvm.sh
rvm reload

rvm requirements run

rvm install $rubyVersion

rvm list

rvm use $rubyVersion --default

command -v ruby > /dev/null 2>&1 || {
    echo
    echo 'Error! Ruby is not installed!'
    failure
    echo
    exit 1
}

echo "Ruby v$rubyVersion installed."
success
echo
exit 0
