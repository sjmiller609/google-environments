variable "deployment_id" {}

variable "base_domain" {}

variable "kubeconfig_path" {
  default = ""
  type    = string
}

data "google_storage_object_signed_url" "fullchain" {
  bucket = "${var.deployment_id}-astronomer-certificate"
  path   = "fullchain.pem"
}

data "google_storage_object_signed_url" "privkey" {
  bucket = "${var.deployment_id}-astronomer-certificate"
  path   = "privkey.pem"
}

# for this to work, the content type in the metadata on the
# bucket objects must be "text/plain; charset=utf-8"
data "http" "fullchain" {
  url = data.google_storage_object_signed_url.fullchain.signed_url
}

data "http" "privkey" {
  url = data.google_storage_object_signed_url.privkey.signed_url
}

module "astronomer_cloud" {

  source  = "astronomer/astronomer-cloud/google"
  version = "0.1.208"

  deployment_id          = var.deployment_id
  email                  = "steven@astronomer.io"
  zonal_cluster          = false
  management_api         = "public"
  enable_gvisor          = false
  kubeconfig_path        = var.kubeconfig_path
  do_not_create_a_record = true
  lets_encrypt           = false
  base_domain            = var.base_domain

  tls_cert = data.http.fullchain.body
  tls_key  = data.http.privkey.body
}
