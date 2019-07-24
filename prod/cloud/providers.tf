provider "google" {
  region  = "us-east4"
  zone    = "us-east4-a"
  project = "astronomer-prod-cloud"
}

provider "google-beta" {
  region  = "us-east4"
  zone    = "us-east4-a"
  project = "astronomer-prod-cloud"
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}
