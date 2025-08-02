
resource "google_compute_managed_ssl_certificate" "default" {
  name    = var.certificate_name
  project = var.project_id

  managed {
    domains = var.domains
  }
}


