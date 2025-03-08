output "rds-pri-key" {
  value = tls_private_key.rds-key.private_key_pem
}

output "rds-pub-key" {
  value =  aws_key_pair.rds-pub-key.id
}