variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default = "192.168.0.0/16"
}
variable "pub_sub_count" {
  description = "Number of public subnets"
  type        = number
  default = 2
}

variable "priv_sub_count" {
  description = "Number of private subnets"
  type        = number
  default = 2
}

variable "nat_count" {
  description = "Number of NAT gateways"
  type        = number
  default = 1
}