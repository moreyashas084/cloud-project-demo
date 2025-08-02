# DNS Managed Zone Terraform Module

This Terraform module creates Google Cloud DNS managed zones for both public and private DNS zones. The module is designed to create only the managed zone itself, allowing A records and other DNS records to be managed from separate repositories or modules.

## Features

- Support for both public and private DNS managed zones
- Configurable zone name, DNS name, and description
- Private zone support with VPC network association
- Outputs zone information for use in other modules or repositories

## Usage

### Public Zone Example

```hcl
module "public_zone" {
  source      = "path/to/this/module"
  project_id  = "your-gcp-project-id"
  zone_name   = "example-public-zone"
  dns_name    = "example.com."
  description = "Public managed zone for example.com"
  type        = "public"
}
```

### Private Zone Example

```hcl
module "private_zone" {
  source       = "path/to/this/module"
  project_id   = "your-gcp-project-id"
  zone_name    = "example-private-zone"
  dns_name     = "private.example.com."
  description  = "Private managed zone for private.example.com"
  type         = "private"
  network_urls = ["https://www.googleapis.com/compute/v1/projects/your-gcp-project-id/global/networks/your-vpc-network-name"]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | The GCP project ID | `string` | n/a | yes |
| zone_name | The name of the managed zone | `string` | n/a | yes |
| dns_name | The DNS name of the managed zone (must end with a dot) | `string` | n/a | yes |
| description | A description of the managed zone | `string` | `"Managed zone created by Terraform"` | no |
| type | The type of the managed zone (public or private) | `string` | `"public"` | no |
| network_urls | List of VPC network URLs for private zones | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| managed_zone_id | The ID of the managed zone |
| managed_zone_name | The name of the managed zone |
| name_servers | The list of name servers for the managed zone |
| dns_name | The DNS name of the managed zone |

## Managing A Records from Another Repository

This module only creates the managed zone. To manage A records from another repository, you can use the outputs from this module as inputs to your DNS record resources:

```hcl
# In your DNS records repository/module
resource "google_dns_record_set" "a_record" {
  project      = var.project_id
  managed_zone = var.managed_zone_name  # Use output from this module
  name         = "www.example.com."
  type         = "A"
  ttl          = 300
  rrdatas      = ["192.168.1.1"]
}
```

## Requirements

- Terraform >= 0.13
- Google Cloud Provider >= 3.0

## Providers

| Name | Version |
|------|---------|
| google | >= 3.0 |

## Resources

| Name | Type |
|------|------|
| google_dns_managed_zone.main | resource |

## Notes

- For private zones, ensure that the specified VPC networks exist and are accessible
- The `dns_name` must end with a dot (.) as per DNS standards
- Zone names must be unique within a project
- This module focuses solely on managed zone creation; DNS records should be managed separately for better modularity and separation of concerns

