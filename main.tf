terraform {

}

# Network module - The "aws_network" module stands up core AWS network infrastructure
module "aws_network" {
  source = "./modules/aws_network"
}

# Resources module - The "aws_resources" module stands up various ec2, db, and lambda resources
module "aws_resources" {
  source = "./modules/aws_resources"

  # Variables that need to be defined when running terraform plan and/or terraform apply
  # Ex. terraform apply -var-file=../personal.tfvars
  deployer_public_key = var.deployer_public_key
  inbound_ssh_ip      = var.inbound_ssh_ip
  db_password         = var.db_password

  # Variables from the output of aws_network module
  vpc_id          = module.aws_network.vpc_id
  public_subnet   = module.aws_network.public_subnet
  private_subnet  = module.aws_network.private_subnet
  database_subnet = module.aws_network.database_subnet
}
