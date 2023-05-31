output "rede_vpc_id" {
    value = aws_vpc.rede_vpc.id
}

output "rede_vpc_pub_cidr" {
    value = aws_vpc.rede_vpc.cidr_block
}

output "subnet_pub_cidr" {
    value = aws_subnet.rede_subnet_pub.id
}

output "rede_vpc_priv_cidr" {
    value = aws_vpc.rede_vpc.cidr_block
}

output "subnet_priv_cidr" {
    value = aws_subnet.rede_subnet_priv.id
}