#! /bin/bash

echo "Enter Username"

read user

kubectl config delete-context $user

kubectl delete namespace $user

rm -rf /home/$user

rm -rf $HOME/.certs

rm -rf $HOME/.k8s

rm -rf $HOME/.RBAC

userdel $user


