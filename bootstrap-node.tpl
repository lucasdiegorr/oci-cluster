#!/bin/bash

sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 6443 -j ACCEPT
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 6444 -j ACCEPT
sudo netfilter-persistent save
curl -vk https://${master_private_ip}:6443/cacerts
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC='agent --server https://${master_private_ip}:6443 --token ${token_k3s}' sh -s -