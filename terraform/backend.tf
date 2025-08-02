terraform {
  backend "gcs" {
    bucket  = "gcpproject-terraform-bucket"
    project = "gcppracticedemo-467805"
    region  = "us-central1"
  }
}