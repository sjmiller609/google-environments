#####
# TLS
#####

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

#####
# Stripe
#####

data "google_storage_object_signed_url" "stripe_pk" {
  bucket = "${var.deployment_id}-astronomer-secrets"
  path   = "stripe_pk.txt"
}

data "google_storage_object_signed_url" "stripe_secret_key" {
  bucket = "${var.deployment_id}-astronomer-secrets"
  path   = "stripe_secret_key.txt"
}

# for this to work, the content type in the metadata on the
# bucket objects must be "text/plain; charset=utf-8"
data "http" "stripe_pk" {
  url = data.google_storage_object_signed_url.stripe_pk.signed_url
}

data "http" "stripe_secret_key" {
  url = data.google_storage_object_signed_url.stripe_secret_key.signed_url
}
