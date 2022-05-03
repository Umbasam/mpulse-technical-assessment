# User-defined vars
variable "db_username" {
  default     = "postgres_db_master"
  description = "Username for DB master user"
  type        = string
}

variable "db_password" {
  description = "Password for DB master user"
  type        = string
}

variable "inbound_ssh_ip" {
  description = "This IP, expressed in CIDR notation, will be allowed SSH traffic into the ec2_public bastion host"
  type        = string
}

variable "deployer_public_key" {
  description = "RSA format public key for the keypair used by the EC2 instances"
  type        = string
}

variable "ec2_scheduler_triggers" {
  # Default is using PDT. PST hours are 2 and 16 respectively. Need to figure out solution for the switch-over
  default = {
    "ec2_stop"  = "cron(0 1 * * TUE-SAT *)",
    "ec2_start" = "cron(0 15 * * MON-FRI *)"
  }
}

# Networking vars
variable "region" {
  default     = "us-west-2"
  description = "The AWS region that resources will be deployed into"
  type        = string
}
variable "vpc_id" {
  description = "The VPC this module will deploy resources to"
  type        = string
}

variable "public_subnet" {
  description = "The subnet used for publicly accessible resources"
  type        = string
}

variable "private_subnet" {
  description = "The subnet used for resources that do not need direct in-bound access and are not databases"
  type        = string
}

variable "database_subnet" {
  description = "The subnet used for database resources, which do not need direct in-bound access"
  type        = string
}
