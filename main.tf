locals {
  name = "rds"
}

# Create VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc-name
  cidr = var.vpc-cidr

  azs                = var.azs
  private_subnets    = var.private-subnets-cidr
  public_subnets     = var.public-subnets-cidr
  enable_vpn_gateway = true
  enable_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

#Creating a keypair
module "keypair" {
  source = "./keypair"
}


# Creating an elastic ip
resource "aws_eip" "rds-eip" {
  tags = {
    Name = "rds-eip"
  }
}

# Create Security_Groups rds-CapstoneProject_FrontEnd
resource "aws_security_group" "rds-sg-frontend" {
  name        = "rds-sg-frontend"
  description = "rds-frontend-security-group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }
  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "${local.name}-sg-frontend"
  }
}

# Create Security_Groups rds-CapstoneProject_BackEnd
resource "aws_security_group" "rds-sg-backend" {
  name        = "rds-sg-backend"
  description = "rds-backend-security-group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "mysql access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.rds-sg-frontend]
  }
  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "${local.name}-sg-backend"
  }
}

# Create wordpress webserver
resource "aws_instance" "wordpress-webserver" {
  ami                         = var.ami-webserver # amazon linux # paris region
  instance_type               = var.instance-type
  associate_public_ip_address = true
  subnet_id                   = module.vpc.public_subnets[0]
  key_name                    = module.keypair.rds-pub-key
  vpc_security_group_ids      = [aws_security_group.Team2-capstone-sg-frontend.id]
  user_data                   = templatefile("./rds-userdata.sh")
  tags = {
    Name = "${local.name}-webserver"
  }
}

#creating database subnet group
resource "aws_db_subnet_group" "rds-db-subnet-group" {
  name        = "rds-db-subnet-group"
  subnet_ids  = var.db-subnets-id # Private subnets for security
  description = "Subnet group for Multi-AZ RDS deployment"

  tags = {
    Name = "${local.name}-db-subnet group"
  }
}

# Creating Mysql wordpress database instance
resource "aws_db_instance" "wordpress-db-instance" {
  identifier             = "wordpress-db"
  db_subnet_group_name   = aws_db_subnet_group.rds-db-subnet-group.id
  vpc_security_group_ids = [aws_security_group.rds-sg-backend.id]
  allocated_storage      = 10
  backup_retention_period = 7
  db_name                = var.db-name
  username               = var.db-username
  password               = var.db-password
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  publicly_accessible    = false
  storage_type           = "gp2"

  tags = {
    Name = "wordpress-db-instance"
  }
}

