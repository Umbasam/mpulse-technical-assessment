variable "region" {
  default     = "us-west-2"
  description = "The AWS region that resources will be deployed into"
  type        = string
}

variable "inbound_ssh_ip" {
  description = "This IP, expressed in CIDR notation, will be allowed SSH traffic into the ec2_public bastion host"
  type        = string
}

variable "deployer_public_key" {
  description = "RSA format public key for the keypair used by the EC2 instances"
}

# Subnet definitions
variable "public_subnet" {
  description = "The subnet used for publicly accessible resources"
}

variable "private_subnet" {
  description = "The subnet used for resources that do not need direct in-bound access and are not databases"
}

variable "database_subnet" {
  description = "The subnet used for database resources, which do not need direct in-bound access"
}
