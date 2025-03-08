######################
## VPC
variable "vpc-name" {
  description = "The name of the VPC"
  type        = string
}

variable "vpc-cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "A list of availability zones in the region"
  type        = list(string)
}

variable "private-subnets-cidr" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
}

variable "public-subnets-cidr" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
}

variable "db-subnets-id" {}

######################
# keypair name
variable "keypair-name" {}

# # path to keypair
# variable "path-to-keypair" {
# #   default = "~/Keypairs/eu2acp.pub"
# }

# media bucket name
variable "media-bucket-name" {}

# webserver ami
variable "ami-webserver" {
#   default = "ami-0ca5ef73451e16dc1"
}

# webserver instance type
variable "instance-type" {
#   default = "t2.micro"
}

# database name
variable "db-name" {
#   default = "wordpress_db"
}

# database username
variable "db-username" {
#   default = "admin"
}

# database password
variable "db-password" {
#   default = "Admin123"
}



# # vpc cidr block
# variable "vpc-cidr" {
#     # default = "10.0.0.0/16"
# }

# # public subnet-1 cidr block
# variable "public-subnet1-cidr" {
# #   default = "10.0.1.0/24"
# }

# # public subnet-2 cidr block
# variable "pub-subnet2-cidr" {
# #   default = "10.0.2.0/24"
# }


# # availability zone public subnet 1
# variable "pub-sub1-az" {
# #   default = "eu-west-3a"
# }

# # availability zone public subnet 2
# variable "pub-sub2-az" {
# #   default = "eu-west-3b"
# }

# # private subnet-1 cidr block
# variable "private-subnet1-cidr" {
# #   default = "10.0.3.0/24"
# }

# # private subnet-2 cidr block
# variable "private-subnet2-cidr" {
# #   default = "10.0.4.0/24"
# }
