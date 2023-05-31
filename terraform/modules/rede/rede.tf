resource "aws_vpc" "vpc_pub" {
  cidr_block           = var.rede_vpc_pub_cidr
  enable_dns_hostnames = "true"
}

resource "aws_subnet" "subnet_pub" {
  vpc_id                  = aws_vpc.vpc_pub.id
  cidr_block              = var.subnet_pub_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_vpc" "vpc_priv" {
  cidr_block           = var.rede_vpc_priv_cidr
  enable_dns_hostnames = "true"
}

resource "aws_subnet" "subnet_priv" {
  vpc_id            = aws_vpc.vpc_priv.id
  cidr_block        = var.subnet_priv_cidr
  availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "vpc_pub_igw" {
  vpc_id = aws_vpc.vpc_pub.id
}

resource "aws_vpc_peering_connection" "vpc_peering" {
  peer_vpc_id = aws_vpc.vpc_priv.id
  vpc_id      = aws_vpc.vpc_pub.id
  auto_accept = true
}

resource "aws_route_table" "rt_pub" {
  vpc_id = aws_vpc.vpc_pub.id
  route {
    cidr_block                = "20.0.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_pub_igw.id
  }
}

resource "aws_route_table" "rt_priv" {
  vpc_id = aws_vpc.vpc_priv.id
  route {
    cidr_block                = "10.0.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  }
}

resource "aws_route_table_association" "subnet_pub_to_rt_pub" {
  subnet_id      = aws_subnet.subnet_pub.id
  route_table_id = aws_route_table.rt_pub.id
}

resource "aws_route_table_association" "subnet_priv_to_rt_priv" {
  subnet_id      = aws_subnet.subnet_priv.id
  route_table_id = aws_route_table.rt_priv.id
}