resource "google_compute_subnetwork" "gke_autopilot_subnet" {
  name          = "gke-autopilot-subnet"
  ip_cidr_range = var.autopilot_subnet_cidr
  region        = var.primary_region
  project       = var.gcp_project
  network       = var.vpc_network_name

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = var.pods_cidr
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.services_cidr
  }
}

resource "google_container_cluster" "autopilot" {
  name     = var.cluster_name
  project  = var.gcp_project
  location = var.primary_region

  network    = var.vpc_network_name
  subnetwork = google_compute_subnetwork.gke_autopilot_subnet.self_link

  autopilot {
    enabled = true
  }

  ip_allocation_policy {
    use_ip_aliases               = true
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  private_cluster_config {
    enable_private_nodes   = true
    enable_private_endpoint = true
    master_ipv4_cidr_block = var.master_ipv4_cidr
  }

  # RBAC and metadata
  enable_legacy_abac = false

  # Do not create a default node pool for autopilot-managed clusters.
  remove_default_node_pool = false
}
