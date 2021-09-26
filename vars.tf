variable "AWS_REGION" {
	default = "us-east-1"
}
variable "VPC_CIDR" {
	default = "10.0.0.0/21"
}
variable "VPC_TENANCY" {
	default = "default"
}
variable "VPC_TAG" {
	default = "dcp_vpc_terra"
}
variable "IS_PUBLIC_IP_REQ" {
	default = "true"
}
variable "SUBNET_CIDR_PUB" {
	type = list
	default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}
variable "SUBNET_CIDR_PRI" {
	type = list
	default = ["10.0.6.0/24", "10.0.7.0/24"]
}
variable "PRIVATE_SUBNET_LIMIT" {
	type = number
	default = 2
}


variable "AZs" {
	type = list
	default = ["us-east-1a","us-east-1b","us-east-1c","us-east-1d","us-east-1e","us-east-1f"]
}
# Or
# AWS DATASOURCES DATA
data "aws_availability_zones" "azs" {}
