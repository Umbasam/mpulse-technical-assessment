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

# Pulls latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
}

# Key pair used to connect to bastion host "ec2_public", will define the private EC2 with it as well
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.deployer_public_key
}

# Private EC2 Instance
resource "aws_instance" "ec2_private" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.arn
  subnet_id     = var.private_subnet
}

# Public EC2 Instance
resource "aws_security_group" "ec2_public" {
  name        = "sg_ec2_public"
  description = "Allow SSH inbound from specified IP"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from Inbound IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.inbound_ssh_ip]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg_ec2_public"
  }
}

resource "aws_instance" "ec2_public" {
  ami             = data.aws_ami.amazon_linux_2.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.deployer.arn
  security_groups = aws_security_group.ec2_public.arn
  subnet_id       = var.private_subnet
}