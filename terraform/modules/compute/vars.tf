variable "rede_vpc_id" {}

variable "rede_vpc_pub_cidr" {}

variable "subnet_pub_cidr" {}

variable "rede_vpc_priv_cidr" {}

variable "subnet_priv_cidr" {}

variable "compute_image_id" {
    type = string
    default = "ami-0e38fa17744b2f6a5"
}

variable "compute_instance_type" {
    type = string
    default = "t2.micro"
}

variable "compute_key_name" {
    type = string
    default = "default"
}