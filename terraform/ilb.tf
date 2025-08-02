module "external_lb" {
  source = "./modules/external-lb"

  project_id                = var.gcp_project
  region                    = var.primary_region
  cloud_run_service_name    = "gcp-practice-cloudrun"
  ssl_certificate_self_link = module.ssl_certificate.certificate_self_link
}