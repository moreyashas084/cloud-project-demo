output "gke_cluster_name" {
  value = google_container_cluster.autopilot.name
}

output "gke_cluster_endpoint" {
  value = google_container_cluster.autopilot.endpoint
}

output "gke_subnetwork_self_link" {
  value = google_compute_subnetwork.gke_autopilot_subnet.self_link
}

output "bastion_vm_name" {
  value       = var.enable_bastion ? google_compute_instance.bastion[0].name : null
  description = "Name of the bastion VM"
}

output "bastion_internal_ip" {
  value       = var.enable_bastion ? google_compute_instance.bastion[0].network_interface[0].network_ip : null
  description = "Internal IP of the bastion VM"
}

output "bastion_ssh_command" {
  value       = var.enable_bastion ? "gcloud compute ssh ${google_compute_instance.bastion[0].name} --zone=${google_compute_instance.bastion[0].zone} --project=${var.gcp_project}" : null
  description = "Command to SSH to the bastion"
}
