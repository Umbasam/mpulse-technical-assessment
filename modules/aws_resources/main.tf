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
  key_name      = aws_key_pair.deployer.id
  subnet_id     = var.private_subnet
  tags = {
    Name = "ec2_private"
  }
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
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.id
  subnet_id              = var.public_subnet
  vpc_security_group_ids = [aws_security_group.ec2_public.id]
  tags = {
    Name = "ec2_public"
  }
}

# RDS Postgres DB
# * Create an RDS - Postgres instance
#   * single db instance
#   * 13.x version
#   * db.t4g.micro instance type
#   * in database subnet

resource "aws_db_instance" "this" {
  allocated_storage    = 20
  db_name              = "postgres_db"
  db_subnet_group_name = var.database_subnet
  engine               = "postgres"
  engine_version       = "13.6" # Latest 13.x version release
  instance_class       = "db.t4g.micro"
  password             = var.db_password
  skip_final_snapshot  = true # Disables taking a snapshot before the db's deletion, which is unnecessary for this assessement
  username             = var.db_username
}

# Lambda-based Python function
# * Create Python lambda functions for stopping and starting the private EC2 instance and schedule them to:
#   * stop at 6pm PT every day
#   * start at 8am PT every day

resource "aws_cloudwatch_event_rule" "ec2_scheduler" {
  for_each            = var.ec2_scheduler_triggers
  name                = "ec2_${each.key}"
  description         = "EC2 Scheduler Rule"
  schedule_expression = each.value
}

module "lambda_function" {
  source   = "terraform-aws-modules/lambda/aws"
  for_each = aws_cloudwatch_event_rule.ec2_scheduler

  function_name = "${each.value.name}_function"
  description   = "${each.value.name}_function performs the action at using this schedule: ${each.value.schedule_expression}"
  handler       = "main.lambda_handler"
  runtime       = "python3.8"
  publish       = true

  source_path = "./modules/aws_resources/src/ec2-scheduler"

  environment_variables = {
    SCHEDULER_ACTION = each.value.name
    INSTANCE_ID      = aws_instance.ec2_private.id
  }
  allowed_triggers = {
    CloudwatchEventRule = {
      principal  = "events.amazonaws.com"
      source_arn = each.value.arn
    }
  }
}

resource "aws_cloudwatch_event_target" "ec2_scheduler_function" {
  for_each = var.ec2_scheduler_triggers
  arn      = module.lambda_function[each.key].lambda_function_arn
  rule     = aws_cloudwatch_event_rule.ec2_scheduler[each.key].id
}
