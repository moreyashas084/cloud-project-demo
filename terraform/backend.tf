terraform {
  backend "gcs" {
    bucket  = "gke-config-state-file"
    project = "gke-application-project"
    region  = "us-central1"
  }
}