variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "primary_region" {
  description = "The Google Cloud region for the Cloud Run service"
  type        = string
  default     = "us-central1"
}

variable "cloudrun_name" {
  description = "The name of the Cloud Run service"
  type        = string
}

variable "image_path" {
  description = "The Docker image URL to deploy"
  type        = string
}

variable "container_port" {
  description = "The port on which the application inside the container listens"
  type        = number
  default     = 8000
}

variable "allow_unauthenticated" {
  description = "Whether to allow unauthenticated access to the service"
  type        = bool
  default     = true
}

