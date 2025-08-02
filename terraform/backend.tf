terraform {
  backend "gcs" {
    bucket = "gcpproject-terraform-bucket"
  }
}