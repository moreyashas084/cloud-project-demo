# Random suffix to avoid conflicts
resource "random_string" "bastion_suffix" {
  length  = 4
  special = false
  lower   = true
}

# Service Account for Bastion
resource "google_service_account" "bastion" {
  count        = var.enable_bastion ? 1 : 0
  account_id   = "bastion-sa-${random_string.bastion_suffix.result}"
  project      = var.gcp_project
  display_name = "Bastion Service Account"

  lifecycle {
    create_before_destroy = true
  }
}

# IAM: Grant bastion SA permission to get cluster credentials
resource "google_project_iam_member" "bastion_container_viewer" {
  count   = var.enable_bastion ? 1 : 0
  project = var.gcp_project
  role    = "roles/container.clusterViewer"
  member  = "serviceAccount:${google_service_account.bastion[0].email}"

  depends_on = [google_service_account.bastion]
}

# Bastion VM
resource "google_compute_instance" "bastion" {
  count                     = var.enable_bastion ? 1 : 0
  name                      = "gke-bastion"
  machine_type              = var.bastion_machine_type
  zone                      = "${var.primary_region}-a"
  project                   = var.gcp_project
  allow_stopping_for_update = true
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 20
    }
  }

  network_interface {
    network    = var.vpc_network_name
    subnetwork = google_compute_subnetwork.gke_autopilot_subnet.self_link
    # No external IP for security
  }

  service_account {
    email  = google_service_account.bastion[0].email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = ["bastion"]

  metadata_startup_script = base64encode(templatefile("${path.module}/bastion_startup.sh", {
    CLUSTER_NAME   = var.cluster_name
    CLUSTER_REGION = var.primary_region
    PROJECT_ID     = var.gcp_project
  }))

  depends_on = [
    google_container_cluster.autopilot,
    google_service_account.bastion,
    google_project_iam_member.bastion_container_viewer
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# Firewall: Allow SSH to Bastion
resource "google_compute_firewall" "allow_ssh_to_bastion" {
  count       = var.enable_bastion ? 1 : 0
  name        = "allow-ssh-to-bastion"
  project     = var.gcp_project
  network     = var.vpc_network_name
  direction   = "INGRESS"
  priority    = 1000
  
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.bastion_source_ip_ranges
  target_tags   = ["bastion"]
}

# Firewall: Allow Bastion to reach GKE control plane API (443)
resource "google_compute_firewall" "allow_bastion_to_master" {
  count           = var.enable_bastion ? 1 : 0
  name            = "allow-bastion-to-master-443"
  project         = var.gcp_project
  network         = var.vpc_network_name
  direction       = "EGRESS"
  priority        = 1000
  
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  destination_ranges = [var.master_ipv4_cidr]
  target_tags        = ["bastion"]
}

# Firewall: Allow control plane to reach nodes (kubelets)
resource "google_compute_firewall" "allow_master_to_nodes" {
  name            = "allow-master-to-nodes-10250"
  project         = var.gcp_project
  network         = var.vpc_network_name
  direction       = "INGRESS"
  priority        = 1000
  
  allow {
    protocol = "tcp"
    ports    = ["10250"]
  }

  source_ranges = [var.master_ipv4_cidr]
  target_tags   = ["gke-node"]
}
