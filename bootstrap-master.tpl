#!/bin/bash

sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 6443 -j ACCEPT
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 6444 -j ACCEPT
sudo netfilter-persistent save
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE='644' INSTALL_K3S_EXEC='server' sh -s - --token ${token_k3s}
kubectl get node
#export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
#curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash