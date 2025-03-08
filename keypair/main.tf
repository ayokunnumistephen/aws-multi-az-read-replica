# Create a Key Pair to SSH into EC2 instance
resource "tls_private_key" "rds-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Store the private key locally
resource "local_file" "rds-pri-key" {
  filename        = "rds-pri-key.pem"
  content         = tls_private_key.rds-key.private_key_pem
  file_permission = "600"
}

# Store the public key locally
resource "aws_key_pair" "rds-pub-key" {
  key_name   = "rds-pub-key"
  public_key = tls_private_key.rds-key.public_key_openssh
}