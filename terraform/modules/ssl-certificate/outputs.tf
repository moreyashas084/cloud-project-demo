output "certificate_id" {
  description = "The ID of the SSL certificate"
  value       = google_compute_managed_ssl_certificate.default.id
}

output "certificate_self_link" {
  description = "The self link of the SSL certificate"
  value       = google_compute_managed_ssl_certificate.default.self_link
}


output "certificate_domains" {
  description = "The domains covered by the SSL certificate"
  value       = google_compute_managed_ssl_certificate.default.managed[0].domains
}

