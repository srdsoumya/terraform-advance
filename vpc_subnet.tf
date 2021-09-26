# aws authentication provider
provider "aws" {
  region = "${var.AWS_REGION}"
}
#####################VPC##########################################VPC###########################
#Creating vertual private network in aws (us-east)
resource "aws_vpc" "dcp_vpc_terra" {
  cidr_block = "${var.VPC_CIDR}"
  instance_tenancy = "${var.VPC_TENANCY}"
  
  tags= {
    Name = "${var.VPC_TAG}"
  }
}

#Creating public subnet
resource "aws_subnet" "public_subnet" {
  count = "${length(data.aws_availability_zones.azs.names)}"
  vpc_id     = "${aws_vpc.dcp_vpc_terra.id}"
  cidr_block = "${element(var.SUBNET_CIDR_PUB, count.index)}"
  map_public_ip_on_launch = "${var.IS_PUBLIC_IP_REQ}"
  availability_zone = "${element(data.aws_availability_zones.azs.names, count.index)}"

  tags = {
    Name = "Public Subnet-${count.index+1}"
  }
}

#Creating private subnet
resource "aws_subnet" "private_subnet" {
  count = "${var.PRIVATE_SUBNET_LIMIT}"
  vpc_id     = "${aws_vpc.dcp_vpc_terra.id}"
  cidr_block = "${element(var.SUBNET_CIDR_PRI, count.index)}"
  map_public_ip_on_launch = "${var.IS_PUBLIC_IP_REQ}"
  availability_zone = "${element(data.aws_availability_zones.azs.names, count.index)}"

  tags = {
    Name = "Private Subnet-${count.index+1}"
  }
}

#Creating internet gateway
resource "aws_internet_gateway" "terra_pub_igw" {
  vpc_id = aws_vpc.dcp_vpc_terra.id

  tags = {
    Name = "terra_pub_ig"
  }
}

#Creating public route table
resource "aws_route_table" "terra_pub_rtw" {
  vpc_id = aws_vpc.dcp_vpc_terra.id

  route = [
    {
      cidr_block                = "0.0.0.0/0"
      egress_only_gateway_id    = ""
      gateway_id                = aws_internet_gateway.terra_pub_igw.id
      instance_id               = ""
      ipv6_cidr_block           = ""
      nat_gateway_id            = ""
      network_interface_id      = ""
      transit_gateway_id        = ""
      vpc_peering_connection_id = ""
      carrier_gateway_id        = ""
      destination_prefix_list_id= ""
      local_gateway_id          = ""
      vpc_endpoint_id           = ""
    }    
  ]

  tags = {
    Name = "terra_pub_rtw"
  }
}

#Associating public route table to node group subnet 1a Az
resource "aws_route_table_association" "terra_pub_rtw_assoc_1a" {
  count = "${length(aws_subnet.public_subnet[*].id)}"
  subnet_id      = aws_subnet.public_subnet["${count.index}"].id
  route_table_id = aws_route_table.terra_pub_rtw.id
}

 