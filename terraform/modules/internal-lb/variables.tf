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

variable "network" {
  description = "The VPC network for the internal load balancer"
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork for the internal load balancer"
  type        = string
}

variable "timeout_sec" {
  description = "The timeout for the backend service in seconds"
  type        = number
  default     = 30
}

variable "ip_address" {
  description = "Static internal IP address for the load balancer (optional)"
  type        = string
  default     = ""
}

variable "port_range" {
  description = "Port range for the forwarding rule"
  type        = string
  default     = "80"
}

