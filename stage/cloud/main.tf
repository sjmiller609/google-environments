variable "deployment_id" {}

variable "kubeconfig_path" {
  default = ""
  type    = string
}

module "astronomer_cloud" {

  source  = "astronomer/astronomer-cloud/google"

  # we will use latest for stage cloud,
  # so let's omit this argument
  # version = "0.1.191"

  deployment_id    = var.deployment_id
  dns_managed_zone = "staging-zone"
  email            = "steven@astronomer.io"
  zonal_cluster    = false
  management_api   = "public"
  enable_gvisor    = false
  kubeconfig_path  = var.kubeconfig_path
}
