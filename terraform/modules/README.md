# Google Cloud Load Balancer Modules for Cloud Run

This repository contains Terraform modules for creating internal and external Application Load Balancers for Google Cloud Run services, with support for Google-managed SSL/TLS certificates in the us-central1 region.

## Architecture Overview

The modules in this repository provide a complete solution for load balancing Cloud Run services in Google Cloud Platform. The architecture includes both external and internal Application Load Balancers, designed to handle different traffic patterns and security requirements.

### External Application Load Balancer

The external Application Load Balancer is designed to handle internet-facing traffic and route it to your Cloud Run services. This load balancer operates at the application layer (Layer 7) and provides advanced features such as URL-based routing, SSL termination, and integration with Google Cloud CDN.

Key components of the external load balancer include:

- **Global External IP Address**: A static IP address that serves as the entry point for external traffic
- **URL Map**: Defines routing rules that determine how incoming requests are distributed to backend services
- **Backend Service**: Manages the connection to Cloud Run services through Serverless Network Endpoint Groups (NEGs)
- **Target Proxies**: Handle HTTP and HTTPS traffic, with the HTTPS proxy managing SSL termination
- **Forwarding Rules**: Direct traffic from the external IP to the appropriate target proxy
- **Serverless NEG**: A specialized Network Endpoint Group that connects the load balancer to Cloud Run services

### Internal Application Load Balancer

The internal Application Load Balancer is designed for private, VPC-internal traffic routing. This is particularly useful for microservices architectures where services need to communicate securely within your private network without exposing endpoints to the internet.

Key components of the internal load balancer include:

- **Regional Internal IP Address**: A private IP address within your VPC network
- **Regional URL Map**: Similar to the external version but scoped to a specific region
- **Regional Backend Service**: Manages internal traffic distribution to Cloud Run services
- **Regional Target HTTP Proxy**: Handles internal HTTP traffic routing
- **Internal Forwarding Rule**: Routes traffic within the VPC to the target proxy
- **Serverless NEG**: Connects the internal load balancer to Cloud Run services

### SSL/TLS Certificate Management

Google-managed SSL certificates provide automated certificate provisioning, renewal, and deployment. These certificates are fully managed by Google Cloud and integrate seamlessly with Application Load Balancers.

Benefits of Google-managed certificates include:

- **Automatic Provisioning**: Certificates are automatically created and validated
- **Automatic Renewal**: No manual intervention required for certificate renewal
- **Domain Validation**: Google automatically validates domain ownership
- **Integration**: Seamless integration with Google Cloud Load Balancers
- **Cost-Effective**: No additional charges for certificate management

## Module Structure

The repository is organized into the following modules:

```
modules/
├── external-lb/          # External Application Load Balancer
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── internal-lb/          # Internal Application Load Balancer
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── ssl-certificate/      # Google-managed SSL Certificate
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

## Prerequisites

Before using these modules, ensure you have the following prerequisites in place:

1. **Google Cloud Project**: A valid Google Cloud Project with billing enabled
2. **Terraform**: Terraform version 0.14 or later installed
3. **Google Cloud SDK**: The gcloud CLI tool installed and configured
4. **Authentication**: Proper authentication configured for Terraform to access Google Cloud
5. **APIs Enabled**: The following Google Cloud APIs must be enabled:
   - Compute Engine API
   - Cloud Run API
   - Cloud Resource Manager API

### Enabling Required APIs

You can enable the required APIs using the following gcloud commands:

```bash
gcloud services enable compute.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
```

### Authentication Setup

Configure authentication for Terraform using one of the following methods:

#### Service Account Key (Recommended for CI/CD)

1. Create a service account with the necessary permissions
2. Download the service account key file
3. Set the environment variable:

```bash
export GOOGLE_APPLICATION_CREDENTIALS="path/to/your/service-account-key.json"
```

#### Application Default Credentials (Recommended for Development)

```bash
gcloud auth application-default login
```

## Usage

### Basic Usage

Here's a basic example of how to use all three modules together:

```hcl
provider "google" {
  project = var.project_id
  region  = var.region
}

# SSL Certificate
module "ssl_certificate" {
  source = "./modules/ssl-certificate"

  project_id       = var.project_id
  certificate_name = "my-app-certificate"
  domains          = ["example.com", "www.example.com"]
}

# External Load Balancer
module "external_lb" {
  source = "./modules/external-lb"

  project_id                = var.project_id
  region                    = var.region
  cloud_run_service_name    = "my-cloud-run-service"
  ssl_certificate_self_link = module.ssl_certificate.certificate_self_link
}

# Internal Load Balancer
module "internal_lb" {
  source = "./modules/internal-lb"

  project_id             = var.project_id
  region                 = var.region
  cloud_run_service_name = "my-cloud-run-service"
  network                = "my-vpc-network"
  subnetwork             = "my-subnetwork"
}
```

### Advanced Configuration

For more advanced use cases, you can customize various aspects of the load balancers:

#### External Load Balancer with CDN

```hcl
module "external_lb" {
  source = "./modules/external-lb"

  project_id                = var.project_id
  region                    = var.region
  cloud_run_service_name    = "my-cloud-run-service"
  ssl_certificate_self_link = module.ssl_certificate.certificate_self_link
  enable_cdn                = true
  timeout_sec               = 60
}
```

#### Internal Load Balancer with Custom IP

```hcl
module "internal_lb" {
  source = "./modules/internal-lb"

  project_id             = var.project_id
  region                 = var.region
  cloud_run_service_name = "my-cloud-run-service"
  network                = "my-vpc-network"
  subnetwork             = "my-subnetwork"
  ip_address             = "10.0.1.100"
}
```

## Module Documentation

### External Load Balancer Module

#### Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | The GCP project ID | `string` | n/a | yes |
| region | The GCP region for the load balancer | `string` | `"us-central1"` | no |
| cloud_run_service_name | The name of the Cloud Run service to route traffic to | `string` | n/a | yes |
| ssl_certificate_self_link | The self link of the SSL certificate to use for HTTPS | `string` | n/a | yes |
| enable_cdn | Whether to enable Cloud CDN for the backend service | `bool` | `false` | no |
| timeout_sec | The timeout for the backend service in seconds | `number` | `30` | no |
| custom_domain | Custom domain for the load balancer (optional) | `string` | `""` | no |
| enable_http_redirect | Whether to redirect HTTP traffic to HTTPS | `bool` | `true` | no |

#### Outputs

| Name | Description |
|------|-------------|
| external_ip_address | The external IP address of the load balancer |
| url_map_id | The ID of the URL map |
| backend_service_id | The ID of the backend service |
| neg_id | The ID of the Network Endpoint Group |
| https_proxy_id | The ID of the HTTPS target proxy |
| http_proxy_id | The ID of the HTTP target proxy |
| https_forwarding_rule_id | The ID of the HTTPS forwarding rule |
| http_forwarding_rule_id | The ID of the HTTP forwarding rule |

### Internal Load Balancer Module

#### Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | The GCP project ID | `string` | n/a | yes |
| region | The GCP region for the load balancer | `string` | `"us-central1"` | no |
| cloud_run_service_name | The name of the Cloud Run service to route traffic to | `string` | n/a | yes |
| network | The VPC network for the internal load balancer | `string` | n/a | yes |
| subnetwork | The subnetwork for the internal load balancer | `string` | n/a | yes |
| timeout_sec | The timeout for the backend service in seconds | `number` | `30` | no |
| ip_address | Static internal IP address for the load balancer (optional) | `string` | `""` | no |
| port_range | Port range for the forwarding rule | `string` | `"80"` | no |

#### Outputs

| Name | Description |
|------|-------------|
| internal_ip_address | The internal IP address of the load balancer |
| url_map_id | The ID of the URL map |
| backend_service_id | The ID of the backend service |
| neg_id | The ID of the Network Endpoint Group |
| http_proxy_id | The ID of the HTTP target proxy |
| forwarding_rule_id | The ID of the forwarding rule |

### SSL Certificate Module

#### Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | The GCP project ID | `string` | n/a | yes |
| certificate_name | The name of the SSL certificate | `string` | n/a | yes |
| domains | List of domains for the SSL certificate | `list(string)` | n/a | yes |

#### Outputs

| Name | Description |
|------|-------------|
| certificate_id | The ID of the SSL certificate |
| certificate_self_link | The self link of the SSL certificate |
| certificate_status | The status of the SSL certificate |
| certificate_domains | The domains covered by the SSL certificate |

## Deployment Guide

### Step 1: Prepare Your Environment

1. Clone this repository to your local machine
2. Navigate to the examples directory
3. Copy the example terraform.tfvars file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

4. Edit the terraform.tfvars file with your specific values:

```hcl
project_id = "your-gcp-project-id"
region     = "us-central1"
domains    = ["yourdomain.com", "www.yourdomain.com"]
network    = "your-vpc-network"
subnetwork = "your-subnetwork"
```

### Step 2: Initialize Terraform

```bash
terraform init
```

### Step 3: Plan the Deployment

```bash
terraform plan
```

Review the planned changes to ensure they match your expectations.

### Step 4: Apply the Configuration

```bash
terraform apply
```

Type `yes` when prompted to confirm the deployment.

### Step 5: Verify the Deployment

After the deployment completes, you can verify the resources were created successfully:

```bash
# Check the external IP address
terraform output external_ip_address

# Check the internal IP address
terraform output internal_ip_address

# Check the SSL certificate status
terraform output ssl_certificate_status
```

## SSL Certificate Validation

Google-managed SSL certificates require domain validation before they become active. The validation process typically takes a few minutes to several hours, depending on your domain configuration.

### Validation Process

1. **DNS Configuration**: Ensure your domain's DNS records point to the load balancer's external IP address
2. **Certificate Provisioning**: Google will automatically provision the certificate once domain ownership is verified
3. **Status Monitoring**: You can monitor the certificate status using the Terraform output or the Google Cloud Console

### DNS Configuration Example

For a domain like `example.com`, you would need to create the following DNS records:

```
A    example.com        -> [EXTERNAL_IP_ADDRESS]
A    www.example.com    -> [EXTERNAL_IP_ADDRESS]
```

Replace `[EXTERNAL_IP_ADDRESS]` with the actual IP address output from the external load balancer module.

### Troubleshooting Certificate Issues

If your certificate remains in a "PROVISIONING" state for an extended period, check the following:

1. **DNS Propagation**: Ensure DNS changes have propagated globally
2. **Domain Accessibility**: Verify that your domain is accessible from the internet
3. **Load Balancer Configuration**: Confirm that the load balancer is properly configured and healthy
4. **Firewall Rules**: Check that there are no firewall rules blocking HTTP/HTTPS traffic

## Security Considerations

### Network Security

When deploying these load balancers, consider the following security best practices:

1. **VPC Configuration**: Use custom VPC networks instead of the default network for better security isolation
2. **Firewall Rules**: Implement appropriate firewall rules to control traffic flow
3. **IAM Permissions**: Follow the principle of least privilege when assigning IAM roles
4. **Private Google Access**: Enable Private Google Access for internal communications

### SSL/TLS Security

1. **Certificate Management**: Use Google-managed certificates for automatic renewal and management
2. **TLS Versions**: Ensure only secure TLS versions are supported (TLS 1.2 and above)
3. **HTTPS Redirect**: Enable HTTP to HTTPS redirection to ensure all traffic is encrypted
4. **HSTS Headers**: Consider implementing HTTP Strict Transport Security headers

### Cloud Run Security

1. **Service Authentication**: Configure appropriate authentication for your Cloud Run services
2. **Ingress Controls**: Use ingress controls to limit traffic sources
3. **Service Accounts**: Use dedicated service accounts with minimal required permissions
4. **Container Security**: Regularly update container images and scan for vulnerabilities

## Monitoring and Observability

### Load Balancer Metrics

Google Cloud provides comprehensive monitoring for load balancers through Cloud Monitoring. Key metrics to monitor include:

1. **Request Count**: Total number of requests processed
2. **Request Latency**: Response time for requests
3. **Error Rate**: Percentage of requests resulting in errors
4. **Backend Health**: Health status of backend services
5. **SSL Certificate Status**: Certificate validity and expiration

### Setting Up Monitoring

You can set up monitoring and alerting using the following approaches:

1. **Cloud Monitoring Dashboard**: Create custom dashboards to visualize load balancer metrics
2. **Alerting Policies**: Set up alerts for critical metrics like high error rates or latency
3. **Log Analysis**: Use Cloud Logging to analyze request logs and identify issues
4. **Uptime Checks**: Configure uptime monitoring to ensure service availability

### Example Monitoring Configuration

```hcl
resource "google_monitoring_alert_policy" "high_error_rate" {
  display_name = "High Error Rate"
  combiner     = "OR"
  
  conditions {
    display_name = "Error rate above 5%"
    
    condition_threshold {
      filter          = "resource.type=\"gce_instance\""
      comparison      = "COMPARISON_GREATER_THAN"
      threshold_value = 0.05
      duration        = "300s"
      
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
  
  notification_channels = [google_monitoring_notification_channel.email.id]
}
```

## Cost Optimization

### Load Balancer Costs

Understanding the cost structure of Google Cloud Load Balancers helps optimize your spending:

1. **Forwarding Rules**: Charged per forwarding rule per hour
2. **Data Processing**: Charged per GB of data processed
3. **Global vs Regional**: Global load balancers may have different pricing than regional ones
4. **SSL Certificates**: Google-managed certificates are included at no additional cost

### Optimization Strategies

1. **Right-sizing**: Choose the appropriate load balancer type for your traffic patterns
2. **Regional Deployment**: Use regional load balancers when global distribution isn't required
3. **CDN Integration**: Enable Cloud CDN to reduce data processing costs
4. **Traffic Analysis**: Regularly analyze traffic patterns to optimize configuration

## Troubleshooting

### Common Issues and Solutions

#### Issue: SSL Certificate Stuck in PROVISIONING State

**Symptoms**: The SSL certificate remains in "PROVISIONING" status for an extended period.

**Solutions**:
1. Verify DNS records point to the correct IP address
2. Ensure the domain is accessible from the internet
3. Check that the load balancer is properly configured
4. Wait for DNS propagation (can take up to 48 hours)

#### Issue: 502 Bad Gateway Errors

**Symptoms**: Users receive 502 errors when accessing the application.

**Solutions**:
1. Check Cloud Run service health and logs
2. Verify the NEG configuration points to the correct Cloud Run service
3. Ensure the Cloud Run service is deployed and running
4. Check for any IAM permission issues

#### Issue: Internal Load Balancer Not Accessible

**Symptoms**: Internal services cannot reach the internal load balancer.

**Solutions**:
1. Verify VPC network and subnetwork configuration
2. Check firewall rules allow traffic on the required ports
3. Ensure the client is in the same VPC network
4. Verify the internal IP address is correctly configured

#### Issue: High Latency

**Symptoms**: Requests take longer than expected to complete.

**Solutions**:
1. Check Cloud Run service performance and scaling settings
2. Analyze load balancer metrics for bottlenecks
3. Consider enabling Cloud CDN for static content
4. Review backend service timeout settings

### Debugging Commands

Use these commands to debug issues:

```bash
# Check load balancer status
gcloud compute url-maps describe [URL_MAP_NAME] --global

# Check backend service health
gcloud compute backend-services describe [BACKEND_SERVICE_NAME] --global

# Check SSL certificate status
gcloud compute ssl-certificates describe [CERTIFICATE_NAME] --global

# View Cloud Run service logs
gcloud logging read "resource.type=cloud_run_revision" --limit=50

# Check NEG status
gcloud compute network-endpoint-groups describe [NEG_NAME] --region=[REGION]
```

## Contributing

We welcome contributions to improve these Terraform modules. Please follow these guidelines:

1. **Fork the Repository**: Create a fork of this repository
2. **Create a Branch**: Create a feature branch for your changes
3. **Make Changes**: Implement your improvements or fixes
4. **Test Changes**: Thoroughly test your changes in a development environment
5. **Submit Pull Request**: Create a pull request with a clear description of your changes

### Development Setup

1. Install required tools:
   - Terraform (>= 0.14)
   - Google Cloud SDK
   - Pre-commit hooks (optional but recommended)

2. Set up authentication:
   ```bash
   gcloud auth application-default login
   ```

3. Run tests:
   ```bash
   terraform fmt -check
   terraform validate
   ```

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Support

For support and questions:

1. **Documentation**: Review this README and module documentation
2. **Issues**: Create an issue in this repository for bugs or feature requests
3. **Google Cloud Support**: For Google Cloud platform issues, contact Google Cloud Support
4. **Community**: Join the Google Cloud community forums for general discussions

## Changelog

### Version 1.0.0
- Initial release with external and internal load balancer modules
- Google-managed SSL certificate support
- Comprehensive documentation and examples
- Support for us-central1 region deployment

---

*This documentation was generated by Manus AI to provide comprehensive guidance for implementing Google Cloud Load Balancers with Cloud Run services.*

