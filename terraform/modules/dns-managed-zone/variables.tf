variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "zone_name" {
  description = "The name of the managed zone"
  type        = string
}

variable "dns_name" {
  description = "The DNS name of the managed zone (must end with a dot)"
  type        = string
}

variable "description" {
  description = "A description of the managed zone"
  type        = string
  default     = "Managed zone created by Terraform"
}

variable "type" {
  description = "The type of the managed zone (public or private)"
  type        = string
  default     = "public"
  
  validation {
    condition     = contains(["public", "private"], var.type)
    error_message = "Type must be either 'public' or 'private'."
  }
}

variable "network_urls" {
  description = "List of VPC network URLs for private zones"
  type        = list(string)
  default     = []
}

