provider google {
  region  = "${var.region}"
  project = "${var.project}"
}

provider google-beta {
  region  = "${var.region}"
  project = "${var.project}"
}

terraform {
  backend "gcs" {
    bucket = "astronomer-cloud-dev-236021-terraform"
    prefix = "terraform/state"
  }
}

data "google_container_engine_versions" "gke" {
  location = "${var.region}"
}
