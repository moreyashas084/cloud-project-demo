variable "gcp_project" {
  type = string
  description = "gcp project id"
}

variable "primary_region" {
  description = "primary region for deployment"
  type = string
}

variable "application_bucket" {
  description = "application tf state bucket"
  type = string
  
}

variable "image_path" {
  description = "path of the image"
  type = string
}