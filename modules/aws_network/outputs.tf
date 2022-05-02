output "vpc_id" {
  value = module.vpc.vpc_arn
}

output "public_subnet" {
  value = module.vpc.public_subnet_arns
}

output "private_subnet" {
  value = module.vpc.private_subnet_arns
}

output "database_subnet" {
  value = module.vpc.database_subnet_arns
}
