module "application_bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 11.0"

  name       = var.application_bucket
  project_id = var.gcp_project
  location   = var.primary_region
}