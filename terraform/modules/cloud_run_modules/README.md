# Google Cloud Run Terraform Module

This Terraform module deploys a Google Cloud Run service, allowing you to easily deploy your containerized applications. It is configured to handle external HTTPS traffic (port 443) by default, while allowing you to specify the internal port your application listens on (e.g., 8000).

## Features

-   Deploys a Google Cloud Run service.
-   Configurable service name, region, and container image.
-   Allows specifying the internal container port (e.g., 8000) while Cloud Run handles external HTTPS (443).
-   Option to allow unauthenticated access for public services.

## Usage

To use this module, you need to provide your Google Cloud project ID, the desired region, a service name, and the Docker image URL.

### Example

```terraform
module "my_cloud_run_service" {
  source = "./path/to/this/module" # Adjust this path to where you save these files

  project_id          = "your-gcp-project-id"
  region              = "us-central1"
  service_name        = "my-fastapi-app"
  image               = "us-central1-docker.pkg.dev/your-gcp-project-id/my-docker-repo/fastapi-app:latest"
  container_port      = 8000
  allow_unauthenticated = true
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_id` | The Google Cloud project ID | `string` | n/a | yes |
| `region` | The Google Cloud region for the Cloud Run service | `string` | `"us-central1"` | no |
| `service_name` | The name of the Cloud Run service | `string` | n/a | yes |
| `image` | The Docker image URL to deploy (e.g., from Artifact Registry) | `string` | n/a | yes |
| `container_port` | The port on which the application inside the container listens | `number` | `8000` | no |
| `allow_unauthenticated` | Whether to allow unauthenticated access to the service | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| `service_url` | The URL of the deployed Cloud Run service |
| `service_name` | The name of the deployed Cloud Run service |
| `service_location` | The location of the deployed Cloud Run service |

## Important Considerations

-   **HTTPS (Port 443) Handling:** Google Cloud Run automatically provides an HTTPS endpoint for your service. You do not need to explicitly configure port 443 in your application or in this Terraform module for external access. Cloud Run handles SSL termination and routes traffic to the `container_port` you specify.
-   **Container Port:** Ensure that the `container_port` variable matches the port your application is actually listening on inside the Docker container (in your case, 8000).
-   **Permissions:** The service account used by Terraform to deploy this Cloud Run service will need appropriate permissions, including `roles/run.admin` for creating and managing Cloud Run services, and potentially `roles/iam.serviceAccountUser` if the Cloud Run service uses a custom service account.
-   **Artifact Registry Image:** The `image` variable should point to your Docker image in Google Cloud Artifact Registry (or Container Registry). Ensure the image is accessible from the region where you are deploying Cloud Run.
-   **Unauthenticated Access:** If `allow_unauthenticated` is set to `true`, your Cloud Run service will be publicly accessible. If you require authenticated access, set this to `false` and manage IAM bindings separately to grant specific users or service accounts the `roles/run.invoker` role.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| google | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| google | >= 4.0 |

## Resources

| Name | Type |
|------|------|
| google_cloud_run_service.default | resource |
| google_cloud_run_service_iam_member.noauth | resource |


