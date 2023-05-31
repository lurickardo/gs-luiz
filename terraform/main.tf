resource "aws_vpc" "vpc_pub" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"
}

resource "aws_subnet" "subnet_pub" {
  vpc_id                  = aws_vpc.vpc_pub.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_vpc" "vpc_priv" {
  cidr_block           = "20.0.0.0/16"
  enable_dns_hostnames = "true"
}

resource "aws_subnet" "subnet_priv" {
  vpc_id            = aws_vpc.vpc_priv.id
  cidr_block        = "20.0.1.0/24"
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

resource "aws_security_group" "sg_pub" {
  vpc_id = aws_vpc.vpc_pub.id
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["20.0.0.0/16"]
  }
  ingress {
    from_port   = "3389"
    to_port     = "3389"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "-1"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_priv" {
  vpc_id = aws_vpc.vpc_priv.id
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["20.0.0.0/16"]
  }
}

resource "aws_instance" "ec2_pub" {
  ami                    = "ami-0e38fa17744b2f6a5"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_pub.id
  vpc_security_group_ids = [aws_security_group.sg_pub.id]
  key_name               = "vockey"
  tags = {
    Name = "ec2_pub"
  }
}

resource "aws_instance" "ec2_priv" {
  ami                    = "ami-0e38fa17744b2f6a5"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_priv.id
  vpc_security_group_ids = [aws_security_group.sg_priv.id]
  key_name               = "vockey"
  tags = {
    Name = "ec2_priv"
  }
}