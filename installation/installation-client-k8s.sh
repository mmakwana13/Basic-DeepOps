#! /bash


sudo swapoff -a

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add

sudo apt install curl

sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

apt-get update

apt-get install kubeadm=1.13.7* kubelet=1.13.7* kubectl=1.13.7*


