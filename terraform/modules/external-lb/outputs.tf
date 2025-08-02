output "external_ip_address" {
  description = "The external IP address of the load balancer"
  value       = google_compute_global_address.default.address
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

output "https_proxy_id" {
  description = "The ID of the HTTPS target proxy"
  value       = google_compute_target_https_proxy.default.id
}

output "http_proxy_id" {
  description = "The ID of the HTTP target proxy"
  value       = google_compute_target_http_proxy.default.id
}

output "https_forwarding_rule_id" {
  description = "The ID of the HTTPS forwarding rule"
  value       = google_compute_global_forwarding_rule.https.id
}

output "http_forwarding_rule_id" {
  description = "The ID of the HTTP forwarding rule"
  value       = google_compute_global_forwarding_rule.http.id
}