resource "google_storage_bucket" "auto-expire" {
  name          = var.application_bucket
  location      = var.primary_region
  project       = var.gcp_project 

  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }
}