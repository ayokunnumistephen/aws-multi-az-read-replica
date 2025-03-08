output "webserver-ip" {
  value = aws_instance.wordpress-webserver.public_ip
}

output "rds-endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.wordpress-db-instance.endpoint
}

output "rds-instance-id" {
  description = "RDS Instance ID" # Useful for monitoring / if alarms or additional configurations needs to be created later
  value       = aws_db_instance.wordpress-db-instance.id
}