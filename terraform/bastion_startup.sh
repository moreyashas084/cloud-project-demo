#!/bin/bash
set -e

echo "Bastion startup script running..."
echo "starting setup for bastion host to access GKE cluster with private endpoint"
# Update system

apt-get update
apt-get install -y \
  curl \
  wget \
  git \
  vim \
  jq

# Install gcloud SDK
curl https://sdk.cloud.google.com | bash
export PATH=$PATH:/root/google-cloud-sdk/bin
source /root/google-cloud-sdk/completion.bash.inc

# Install kubectl and gke-gcloud-auth-plugin via apt-get
sudo apt-get install -y kubectl
sudo apt-get install -y google-cloud-cli-gke-gcloud-auth-plugin

# Get cluster credentials
gcloud container clusters get-credentials autopilot-cluster \
  --region=us-central1 \
  --project=gke-application-project \
  --internal-ip

echo "Bastion setup complete. kubectl is ready."
kubectl get nodes
