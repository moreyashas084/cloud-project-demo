module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 6.0" # Use a compatible version

  project_id   = var.gcp_project
  network_name = "project-serverless-vpc"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "serverless-subnet-us-central1"
      subnet_ip     = "10.0.0.0/24"
      subnet_region = "us-central1"
    }
  ]
}