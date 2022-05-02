module "aws_network" {
  source = "./modules/aws_network"
}

module "aws_resources" {
  source = "./modules/aws_resources"

  availability_zone_one = module.aws_network.availability_zone_one
}
