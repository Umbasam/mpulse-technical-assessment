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

# * All instances should use the latest Amazon Linux 2 AMI
# * Create a t2.micro EC2 instance in the private subnets

# * Create a t2.micro EC2 instance in the public subnets that you can use as a bastion host to access the private hosts.
#   * Be ready to show or explain how you would use this host to connect to the private hosts
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
}

resource "aws_instance" "ec2_private" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  subnet_id     = var.private_subnet

}
