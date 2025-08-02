resource "google_artifact_registry_repository" "my-repo" {
  location      = var.primary_region
  repository_id = "gcp-demo-project-docker-repository"
  description   = "cloud runs docker repository"
  format        = "DOCKER"

  docker_config {
    immutable_tags = true
  }
}