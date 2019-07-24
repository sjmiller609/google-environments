terraform {
  required_version = ">= 0.12"
  backend "gcs" {
    bucket  = "astronomer-prod-terraform-state"
    prefix  = "prod/terraform.tfstate"
  }
}
