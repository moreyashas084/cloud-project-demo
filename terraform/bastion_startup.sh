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
exec -l $SHELL

# Install kubectl
gcloud components install kubectl --quiet

# Get cluster credentials
gcloud container clusters get-credentials ${CLUSTER_NAME} \
  --region=${CLUSTER_REGION} \
  --project=${PROJECT_ID} \
  --internal-ip

echo "Bastion setup complete. kubectl is ready."
kubectl get nodes
