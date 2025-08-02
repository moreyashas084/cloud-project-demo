resource "google_dns_managed_zone" "main" {
  project     = var.project_id
  name        = var.zone_name
  dns_name    = var.dns_name
  description = var.description

  dynamic "private_visibility_config" {
    for_each = var.type == "private" ? [1] : []
    content {
      network_url = var.network_urls
    }
  }
}

