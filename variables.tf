variable "region" {
  default     = "us-west-2"
  description = "The AWS region that resources will be deployed into"
  type        = string
}

variable "default_tags" {
  default = {
    Environment = "dev"
    Owner       = "Jeremy"
    Terraform   = "true"
  }
  description = "Default tags to apply to resources"
  type        = map(string)
}

variable "inbound_ssh_ip" {
  description = "This IP, expressed in CIDR notation, will be allowed SSH traffic into the ec2_public bastion host"
  type        = string
}

variable "deployer_public_key" {
  description = "RSA format public key for the keypair used by the EC2 instances"
}
