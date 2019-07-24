variable "deployment_id" {}

variable "kubeconfig_path" {
  default = ""
  type    = string
}

# Always carefully compare this configuration
# to the staging configuration
module "astronomer_cloud" {

  source  = "astronomer/astronomer-cloud/google"
  version = "0.1.191"

  deployment_id    = var.deployment_id
  email            = "steven@astronomer.io"
  zonal_cluster    = false
  management_api   = "public"
  enable_gvisor    = false
  kubeconfig_path  = var.kubeconfig_path
}
