output "my_vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "nat_gateway_ids" {
  value = module.vpc.nat_gateway_ids
}

output "internet_gateway_id" {
  value = module.vpc.internet_gateway_id
}

output "api_url" {
  value = module.api_gateway.api_url
}