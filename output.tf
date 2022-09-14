###################### OUTPUT ######################

output "ssh_command" {
  value = "ssh -A -i key.pem ubuntu@${aws_instance.jenkins.public_dns}"
}

output "create_private_key_command" {
  value = "terraform output instances_private_key > key.pem && chmod 400 key.pem"
}

output "instances_private_key" {
  value     = tls_private_key.main.private_key_pem
  sensitive = true
}

output "instances_public_key" {
  value     = tls_private_key.main.public_key_openssh
  sensitive = true
}