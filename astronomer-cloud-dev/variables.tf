variable "project" {
  default     = "astronomer-cloud-dev-236021"
  description = "The GCP project to deploy infrastructure into"
}

variable "region" {
  default     = "us-east4"
  description = "The GCP region to deploy infrastructure into"
}

variable "zone" {
  default     = "us-east4-a"
  description = "The GCP zone to deploy infrastructure into"
}
