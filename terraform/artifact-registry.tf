module "artifact_registry" {
  source = "GoogleCloudPlatform/artifact-registry/google"
  version = "~> 0.3" # Specify a suitable version

  project_id    = var.gcp_project
  location      = var.primary_region
  format        = "DOCKER"   # e.g., "DOCKER", "MAVEN", "NPM", "GO", "PYTHON"
  repository_id = "gcp-demo-project-docker-repository"
}