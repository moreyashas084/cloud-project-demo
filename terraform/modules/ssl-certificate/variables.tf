variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "certificate_name" {
  description = "The name of the SSL certificate"
  type        = string
}

variable "domains" {
  description = "List of domains for the SSL certificate"
  type        = list(string)
}

