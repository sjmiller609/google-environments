output "bastion_ip" {
  value = "${module.environment.bastion_ip}"
}

output "postgres_ip" {
  value = "${module.environment.postgres_ip}"
}

output "postgres_user" {
  value = "${module.environment.postgres_user}"
}

output "postgres_password" {
  value = "${module.environment.postgres_password}"
}

output "container_registry_bucket_name" {
  value = "${module.environment.container_registry_bucket_name}"
}
