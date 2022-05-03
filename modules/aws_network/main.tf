terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.12.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name
  cidr = "10.42.0.0/16"

  azs              = ["${var.region}a", "${var.region}b"]
  private_subnets  = ["10.42.1.0/24", "10.42.2.0/24"]
  public_subnets   = ["10.42.11.0/24", "10.42.12.0/24"]
  database_subnets = ["10.42.21.0/24", "10.42.22.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  tags = var.default_tags
}
