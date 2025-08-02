output "internal_ip_address" {
  description = "The internal IP address of the load balancer"
  value       = google_compute_forwarding_rule.default.ip_address
}

output "url_map_id" {
  description = "The ID of the URL map"
  value       = google_compute_url_map.default.id
}

output "backend_service_id" {
  description = "The ID of the backend service"
  value       = google_compute_backend_service.default.id
}

output "neg_id" {
  description = "The ID of the Network Endpoint Group"
  value       = google_compute_region_network_endpoint_group.cloudrun_neg.id
}

output "http_proxy_id" {
  description = "The ID of the HTTP target proxy"
  value       = google_compute_region_target_http_proxy.default.id
}

output "forwarding_rule_id" {
  description = "The ID of the forwarding rule"
  value       = google_compute_forwarding_rule.default.id
}

