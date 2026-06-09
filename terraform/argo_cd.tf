# 3. Fetch data about your EXISTING GKE Autopilot cluster
data "google_container_cluster" "existing_cluster" {
  name     = "autopilot-cluster" # CHANGE THIS to your exact cluster name
  location = "us-central1"           # CHANGE THIS to your cluster's region or zone
}

# 4. Fetch temporary authentication tokens to log into the cluster
data "google_client_config" "default" {}

# 5. Configure Helm to talk directly to your private GKE cluster
provider "helm" {
  kubernetes = {
    host                   = "https://${data.google_container_cluster.existing_cluster.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.existing_cluster.master_auth[0].cluster_ca_certificate)
  }
}

