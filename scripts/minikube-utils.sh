#!/usr/bin/env bash

set_envs() {
        export DOCKER_TLS_VERIFY="1"
        export DOCKER_HOST="tcp://192.168.99.100:2376"
        export DOCKER_CERT_PATH="/home/vagrant/minikube-certs"
        export DOCKER_API_VERSION="1.35"
        echo "Minikube environment variables configured."
}

unset_envs() {
        unset DOCKER_HOST
        unset DOCKER_CERT_PATH
        unset DOCKER_TLS_VERIFY
        unset DOCKER_API_VERSION
        echo "Minikube environment variables removed."
}

bootstrap() {

  server_ips=$1
  server_names=$2

  minikube delete \
    && rm -f /etc/kubernetes/kubelet.conf /etc/kubernetes/admin.conf \
    && rm -rf /root/.kube /root/.minikube \
    && rm -rf /var/lib/minikube/certs/ \
    && rm -rf /etc/kubernetes/

  swapoff -a
  
  minikube start --vm-driver none --apiserver-ips "$server_ips" --apiserver-names "$server_names"
  sudo /usr/bin/kubeadm init --config /var/lib/kubeadm.yaml --ignore-preflight-errors=All

  cp -rv /root/.kube /home/vagrant/.kube \
    && chown -R vagrant /home/vagrant/.kube \
    && chgrp -R vagrant /home/vagrant/.kube

  cp -rv /root/.minikube /home/vagrant/.minikube \
    && chown -R vagrant /home/vagrant/.minikube \
    && chgrp -R vagrant /home/vagrant/.minikube
}

proxy() {
  kubectl proxy --address='0.0.0.0' --disable-filter=true
}

case $1 in
 bootstrap) bootstrap ;;
 set-envs ) set_envs  ;;
 unset-envs ) unset_envs  ;;
 proxy ) proxy  ;;
 *) echo "Use: $0 [bootstrap|set-envs|unset-envs|proxy]" ;;
esac
