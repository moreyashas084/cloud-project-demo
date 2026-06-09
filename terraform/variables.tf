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

variable "bastion_machine_type" {
  description = "Machine type for the bastion VM"
  type = string
  default = "e2-small"
}

variable "bastion_source_ip_ranges" {
  description = "CIDR ranges allowed to SSH to the bastion (restrict to your IP)"
  type = list(string)
  default = ["0.0.0.0/0"] # WARNING: restrict this to your IP or VPN
}

variable "enable_bastion" {
  description = "Whether to create a bastion VM for cluster access"
  type = bool
  default = true
}