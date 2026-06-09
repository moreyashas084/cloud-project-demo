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

# variable "image_path" {
#   description = "path of the image"
#   type = string
# }

variable "cluster_name" {
  description = "Name of the GKE Autopilot cluster"
  type = string
  default = "autopilot-cluster"
}

variable "vpc_network_name" {
  description = "VPC network name to attach the cluster to"
  type = string
  default = "default"
}

variable "autopilot_subnet_cidr" {
  description = "Primary CIDR for the GKE subnet"
  type = string
  default = "10.10.0.0/20"
}

variable "pods_cidr" {
  description = "Secondary range CIDR for GKE pods"
  type = string
  default = "10.11.0.0/20"
}

variable "services_cidr" {
  description = "Secondary range CIDR for GKE services"
  type = string
  default = "10.12.0.0/24"
}

variable "master_ipv4_cidr" {
  description = "CIDR block for the master (control plane) private endpoint"
  type = string
  default = "172.16.0.0/28"
}