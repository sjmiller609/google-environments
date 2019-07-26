variable "deployment_id" {}

variable "base_domain" {}

variable "kubeconfig_path" {
  default = ""
  type    = string
}

module "astronomer_cloud" {

  source  = "astronomer/astronomer-cloud/google"
  version = "0.1.226"

  deployment_id          = var.deployment_id
  email                  = "steven@astronomer.io"
  zonal_cluster          = false
  management_api         = "public"
  enable_gvisor          = false
  kubeconfig_path        = var.kubeconfig_path
  do_not_create_a_record = true
  lets_encrypt           = false
  base_domain            = var.base_domain

  tls_cert          = data.http.fullchain.body
  tls_key           = data.http.privkey.body
  stripe_secret_key = data.http.stripe_secret_key.body
  stripe_pk         = data.http.stripe_pk.body
}
