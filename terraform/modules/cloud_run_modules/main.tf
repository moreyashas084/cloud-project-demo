resource "google_cloud_run_service" "fastapi_app" {
  name     = var.cloudrun_name
  location = var.primary_region
  project = var.project_id

  template {
    spec {
      containers {
        image = var.image_path
        ports {
          container_port = 8080
        }
        resources {
          limits = {
            cpu    = "1"
            memory = "512Mi"
          }
        }
        startup_probe {
          tcp_socket {
            port = 8080
          }
          period_seconds        = 240
          timeout_seconds       = 240
          failure_threshold     = 1
          initial_delay_seconds = 0
        }
        liveness_probe {
          http_get {
            path = "/health"
          }
        }
      }

      container_concurrency = 80
      timeout_seconds       = 300
    }

    metadata {
      annotations = {
        "run.googleapis.com/startup-cpu-boost" = "true"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true
}

resource "google_cloud_run_service_iam_member" "invoker" {
  service = google_cloud_run_service.fastapi_app.name
  location = google_cloud_run_service.fastapi_app.location
  project = google_cloud_run_service.fastapi_app.project

  role   = "roles/run.invoker"
  member = "allUsers" # Update if needed
}
