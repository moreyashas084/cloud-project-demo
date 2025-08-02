module "my_cloud_run_service" {
  source = "./modules/cloud_run_modules"
  project_id = var.gcp_project
  cloudrun_name = "gcp-practice-cloudrun"
  image_path = var.image_path
  primary_region = var.primary_region
  container_port = 8080
}