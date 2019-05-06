provider google {
  region  = "us-east4"
  project = "astronomer-cloud-dev-236021"
}

provider google-beta {
  region  = "us-east4"
  project = "astronomer-cloud-dev-236021"
}

terraform {
  backend "gcs" {
    bucket = "tf-state-ian"
    prefix = "terraform/state"
  }
}
