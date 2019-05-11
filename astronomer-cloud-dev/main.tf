module "environment" {
  source = "git::https://github.com/astronomer/terraform.git//gcp?ref=master"

  bastion_admins = [
    "user:greg@astronomer.io",
    "user:kaxil@astronomer.io",
    "user:ian@astronomer.io",
  ]

  bastion_users = [
    "user:greg@astronomer.io",
    "user:kaxil@astronomer.io",
    "user:ian@astronomer.io",
  ]

  # GKE Config
  cluster_name                     = "cloud-dev-cluster"
  gke_secondary_ip_ranges_pods     = "10.32.0.0/14"
  gke_secondary_ip_ranges_services = "10.98.0.0/20"
  machine_type                     = "f1-micro"
  min_node_count                   = 1
  max_node_count                   = 20
  min_master_version               = "${data.google_container_engine_versions.gke.latest_master_version}"
  node_version                     = "${data.google_container_engine_versions.gke.latest_node_version}"

  region = "${var.region}"
  zone   = "${var.zone}"
}
