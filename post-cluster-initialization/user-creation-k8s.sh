
#! /bin/bash


echo "Enter user"
read username

echo "Validity of certificate (In days)"

read cert_id

cd $HOME/.certs
mkdir $username

kubectl create namespace $username

openssl genrsa -out $HOME/.certs/$username/$username.key 2048

openssl req -new -key $HOME/.certs/$username/$username.key -out $HOME/.certs/$username/$username.csr -subj /CN=$username

openssl x509 -req -in $HOME/.certs/$username/$username.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out $HOME/.certs/$username/$username.crt -days $cert_id

kubectl config set-credentials $username --client-certificate=$HOME/.certs/$username/$username.crt --client-key=$HOME/.certs/$username/$username.key

kubectl config set-context $username --cluster=kubernetes --namespace=$username --user=$username

cd $HOME


cat <<EOF >$HOME/.RBAC/${username}-RoleBinding.yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: owner-binding
  namespace: $username
subjects:
- kind: User
  name: $username
  apiGroup: ""
roleRef:
  kind: ClusterRole
  name: owner
  apiGroup: ""
EOF


cp $HOME/DeepOps/01-ClusterRole.yaml $HOME/.RBAC/
cd $HOME/.RBAC

kubectl apply -f 01-ClusterRole.yaml
cd $HOME/.RBAC
kubectl apply -f ${username}-RoleBinding.yaml



cd /etc/kubernetes/
sed -n '1,9 p' admin.conf > $HOME/.certs/$username/$username.config
cat <<EOT >> $HOME/.certs/$username/$username.config
    namespace: $username
    user: $username
  name: $username
current-context: $username
kind: Config
preferences: {}
users:
- name: $username
  user:
    client-certificate: $username.crt
    client-key: $username.key
EOT

adduser $username

cd /home

chmod 700 $username

chown $username $username

cp $HOME/.certs/$username/* /home/$username/

rm /home/$username/$username.csr

cp $HOME/DeepOps/post-user-creation/pod-creation.sh /home/$username/


cd /home/$username

chown $username *

cd $HOME/.k8s/



#kubectl create -f quota.yaml --namespace=$username
