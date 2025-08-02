variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for the load balancer"
  type        = string
  default     = "us-central1"
}

variable "cloud_run_service_name" {
  description = "The name of the Cloud Run service to route traffic to"
  type        = string
}

variable "ssl_certificate_self_link" {
  description = "The self link of the SSL certificate to use for HTTPS"
  type        = string
}

variable "enable_cdn" {
  description = "Whether to enable Cloud CDN for the backend service"
  type        = bool
  default     = false
}

variable "timeout_sec" {
  description = "The timeout for the backend service in seconds"
  type        = number
  default     = 30
}

variable "custom_domain" {
  description = "Custom domain for the load balancer (optional)"
  type        = string
  default     = ""
}

variable "enable_http_redirect" {
  description = "Whether to redirect HTTP traffic to HTTPS"
  type        = bool
  default     = true
}

