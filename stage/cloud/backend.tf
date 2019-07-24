terraform {
  required_version = ">= 0.12"
  backend "gcs" {
    bucket  = "astronomer-staging-terraform-state"
    prefix  = "stage/terraform.tfstate"
  }
}
