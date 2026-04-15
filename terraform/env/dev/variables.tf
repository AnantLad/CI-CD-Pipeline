variable "environment" {
  description = "Enviroment name (dev,prod)"
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "public_subnet" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}
variable "private_subnet" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}
variable "availability_zones" {
  description = "List of availability zones for the subnets"
  type        = list(string)
}
