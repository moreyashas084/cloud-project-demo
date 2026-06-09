output "gke_cluster_name" {
  value = google_container_cluster.autopilot.name
}

output "gke_cluster_endpoint" {
  value = google_container_cluster.autopilot.endpoint
}

output "gke_subnetwork_self_link" {
  value = google_compute_subnetwork.gke_autopilot_subnet.self_link
}
