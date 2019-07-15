echo "Enter container image name"
read container

echo "Enter container name"
read name

echo "Enter the number of GPus required"
read gpu
cat <<EOF >$HOME/${name}-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: $name
spec:
  volumes:
  - name: shared-data
    emptyDir: {}
  securityContext:
    runAsUser: $(id -u)
    fsGroup: $(id -g)
  containers:
  - name: $name
    image: $container
    resources:
      limits:
        nvidia.com/gpu: $gpu
    command: [ "/bin/bash", "-c", "--" ]
    args: [ "while true; do sleep 1; done;" ]
    ports:
    - containerPort: 8888
    volumeMounts:
    - name: ${name}-data
      mountPath: /workspace
  volumes:
  - name: ${name}-data
    hostPath:
      path: /raid/$(whoami)
      type: Directory
  hostNetwork: true
  dnsPolicy: Default
EOF

cd $HOME
kubectl create -f ${name}-pod.yaml 
rm $name-pod.yaml
