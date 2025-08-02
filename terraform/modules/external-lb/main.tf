
resource "google_compute_url_map" "default" {
  name        = "${var.project_id}-external-url-map"
  description = "A default URL map that routes all traffic to the Cloud Run service."

  default_service = google_compute_backend_service.default.id
}

resource "google_compute_backend_service" "default" {
  name                  = "${var.project_id}-external-backend-service"
  protocol              = "HTTP"
  timeout_sec           = 30
  enable_cdn            = false
  load_balancing_scheme = "EXTERNAL"

  backend {
    group = google_compute_region_network_endpoint_group.cloudrun_neg.id
  }
}

resource "google_compute_region_network_endpoint_group" "cloudrun_neg" {
  name                  = "${var.project_id}-cloudrun-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = var.cloud_run_service_name
  }
}

resource "google_compute_target_https_proxy" "default" {
  name             = "${var.project_id}-external-https-proxy"
  url_map          = google_compute_url_map.default.id
  ssl_certificates = [var.ssl_certificate_self_link]
}

resource "google_compute_global_forwarding_rule" "https" {
  name       = "${var.project_id}-external-https-forwarding-rule"
  ip_protocol = "TCP"
  port_range = "443"
  load_balancing_scheme = "EXTERNAL"
  target     = google_compute_target_https_proxy.default.id
  ip_address = google_compute_global_address.default.id
}

resource "google_compute_global_address" "default" {
  name = "${var.project_id}-external-ip"
}

resource "google_compute_target_http_proxy" "default" {
  name    = "${var.project_id}-external-http-proxy"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_global_forwarding_rule" "http" {
  name       = "${var.project_id}-external-http-forwarding-rule"
  ip_protocol = "TCP"
  port_range = "80"
  load_balancing_scheme = "EXTERNAL"
  target     = google_compute_target_http_proxy.default.id
  ip_address = google_compute_global_address.default.id
}


