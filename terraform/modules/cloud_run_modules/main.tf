resource "google_cloud_run_service" "default" {
  name     = var.cloudrun_name
  location = var.primary_region
  project = var.project_id
  template {
    spec {
      containers {
        image = var.image_path
        startup_probe {
          initial_delay_seconds = 0
          timeout_seconds = 1
          period_seconds = 3
          failure_threshold = 1
          tcp_socket {
            port = var.container_port
          }
        }
        liveness_probe {
          http_get {
            path = "/health"
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  lifecycle {
    ignore_changes = [
      metadata.0.annotations,
    ]
  }
}