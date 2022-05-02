module "aws_network" {
  source = "./modules/aws_network"
}

module "aws_resources" {
  source = "./modules/aws_resources"

  vpc_id              = module.aws_network.vpc_id
  public_subnet       = module.aws_network.public_subnet
  private_subnet      = module.aws_network.private_subnet
  database_subnet     = module.aws_network.database_subnet
  deployer_public_key = var.deployer_public_key
  inbound_ssh_ip      = var.inbound_ssh_ip
}
