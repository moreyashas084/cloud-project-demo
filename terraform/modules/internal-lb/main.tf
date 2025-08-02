
resource "google_compute_url_map" "default" {
  name        = "${var.project_id}-internal-url-map"
  description = "A default URL map that routes all traffic to the Cloud Run service."

  default_service = google_compute_backend_service.default.id
}

resource "google_compute_backend_service" "default" {
  name                  = "${var.project_id}-internal-backend-service"
  protocol              = "HTTP"
  timeout_sec           = 30
  enable_cdn            = false
  load_balancing_scheme = "INTERNAL_MANAGED"

  backend {
    group = google_compute_region_network_endpoint_group.cloudrun_neg.id
  }
}

resource "google_compute_region_network_endpoint_group" "cloudrun_neg" {
  name                  = "${var.project_id}-cloudrun-internal-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = var.cloud_run_service_name
  }
}

resource "google_compute_region_target_http_proxy" "default" {
  name    = "${var.project_id}-internal-http-proxy"
  url_map = google_compute_url_map.default.id
  region  = var.region
}

resource "google_compute_forwarding_rule" "default" {
  name                  = "${var.project_id}-internal-forwarding-rule"
  ip_protocol           = "TCP"
  port_range            = "80"
  load_balancing_scheme = "INTERNAL_MANAGED"
  target                = google_compute_region_target_http_proxy.default.id
  region                = var.region
  network               = var.network
  subnetwork            = var.subnetwork
}


