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
