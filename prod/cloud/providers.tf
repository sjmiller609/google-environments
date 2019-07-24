provider "google" {
  region  = "us-east4"
  zone    = "us-east4-a"
  project = "astronomer-cloud-prod"
}

provider "google-beta" {
  region  = "us-east4"
  zone    = "us-east4-a"
  project = "astronomer-cloud-prod"
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}
