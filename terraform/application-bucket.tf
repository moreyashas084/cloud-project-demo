module "application_bucket" {
  source = "./modules/application-bucket"
  application_bucket = var.application_bucket
  primary_region = var.primary_region
  gcp_project = var.gcp_project
}