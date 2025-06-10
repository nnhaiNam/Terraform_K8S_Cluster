#!/bin/bash

echo "#################################"
echo "Init Cluster K8S"

#Update hostname on system
sudo hostnamectl set-hostname "k8s-master-1"

#Init cluster
sudo kubeadm init --control-plane-endpoint "192.168.1.111:6443" --upload-certs
mkdir -p /home/ubuntu/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
sudo chown -R ubuntu:ubuntu /home/ubuntu/.kube/


#Update hostname before join cluster
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 60")
privateip=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)
clusterPrefix=$(aws ssm get-parameter --name $privateip-cluster-prefix --output text --query "Parameter.Value")

#Update k8s_join_command param
aws ssm put-parameter \
  --name="$clusterPrefix-join-cluster" \
  --type=String \
  --value="$(cat /var/log/cloud-init-output.log | grep 'kubeadm join' -A2 |  head -n3)" \
  --overwrite


# Install calico CNI
max_attempts=60  # Total waiting time: 60 * 5 seconds = 5 minutes
attempt=0

while [ $attempt -lt $max_attempts ]; do
    if kubectl --kubeconfig /home/ubuntu/.kube/config get nodes &> /dev/null; then
        echo "kubectl get nodes succeeded."
        kubectl --kubeconfig /home/ubuntu/.kube/config apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml      
        break
    else
        echo "attempt=$attempt: kubernetes cluster is not ready yet..."
        sleep 10
        ((attempt++))
    fi
done




while true; do
  # Lấy danh sách node, trừ dòng đầu
  node_count=$(kubectl --kubeconfig /home/ubuntu/.kube/config get nodes --no-headers | awk '$2 == "Ready"' | wc -l)

  echo "Đã phát hiện $node_count node control-plane..."

  # Nếu đủ 3 node, break
  if [ "$node_count" -eq 3 ]; then
    echo "Tất cả 3 node đã join. Bỏ taint..."
    break
  fi

  sleep 10
done

# Bỏ taint sau khi đã đủ 3 node
kubectl --kubeconfig /home/ubuntu/.kube/config taint nodes k8s-master-1 node-role.kubernetes.io/control-plane:NoSchedule-
kubectl --kubeconfig /home/ubuntu/.kube/config taint nodes k8s-master-2 node-role.kubernetes.io/control-plane:NoSchedule-
kubectl --kubeconfig /home/ubuntu/.kube/config taint nodes k8s-master-3 node-role.kubernetes.io/control-plane:NoSchedule-


#Install Helm
sudo wget https://get.helm.sh/helm-v3.18.2-linux-amd64.tar.gz
sudo tar xvf helm-v3.18.2-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/bin/

# Install Nginx Ingress Controller
kubectl --kubeconfig /home/ubuntu/.kube/config create namespace ingress-nginx 
kubectl --kubeconfig /home/ubuntu/.kube/config create serviceaccount nginx-ingress-controller
kubectl --kubeconfig create clusterrolebinding nginx-ingress-controller --clusterrole=cluster-admin --serviceaccount=default:nginx-ingress-controller
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
# helm install nginx-ingress ingress-nginx/ingress-nginx \
#   --namespace ingress-nginx --create-namespace \
#   --set controller.service.type=NodePort \
#   --set controller.service.nodePorts.http=30080 \
#   --set controller.service.nodePorts.https=30443 \
#   --set controller.admissionWebhooks.enabled=false \
#   --set controller.admissionWebhooks.patch.enabled=false \
#    --kubeconfig /home/ubuntu/.kube/config
 
helm install nginx-ingress ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --set controller.kind=DaemonSet \
  --set controller.hostPort.enabled=true \
  --set controller.service.type=NodePort \
  --set controller.service.nodePorts.http=30080 \
  --set controller.service.nodePorts.https=30443 \
  --set controller.admissionWebhooks.enabled=false \
  --set controller.admissionWebhooks.patch.enabled=false \
  --kubeconfig /home/ubuntu/.kube/config


#Install ArgoCD
kubectl --kubeconfig /home/ubuntu/.kube/config create namespace argocd
kubectl --kubeconfig /home/ubuntu/.kube/config apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
