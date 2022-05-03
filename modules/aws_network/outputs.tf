output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet" {
  value = module.vpc.public_subnets[0]
}

output "private_subnet" {
  value = module.vpc.private_subnets[0]
}

output "database_subnet" {
  value = module.vpc.database_subnet_group
}
