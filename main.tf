module "aws_network" {
  source = "./modules/aws_network"
}

module "aws_resources" {
  source = "./modules/aws_resources"

  vpc_id = module.aws_network.vpc_id
}
