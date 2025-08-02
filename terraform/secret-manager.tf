module "ssl_certificate" {
  source = "./modules/ssl-certificate"
  project_id       = var.gcp_project
  certificate_name = "my-app-certificate"
  domains          = ["www.practice.projects.com"]
}