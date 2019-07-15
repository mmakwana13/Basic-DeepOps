#! /bin/bash



curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add

sudo apt install curl

sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

apt-get update

apt-get install kubeadm=1.13.7* kubelet=1.13.7* kubectl=1.13.7*

swapoff -a 

sudo kubeadm init

cd $HOME

mkdir .certs
mkdir .RBAC
mkdir .k8s

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

kubectl create -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v1.11/nvidia-device-plugin.yml
