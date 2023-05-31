variable "rede_vpc_pub_cidr" {
  type      = string
  default   = "10.0.0.0/16"
}

variable "subnet_pub_cidr" {
    type        = string
    default     = "10.0.1.0/24"
}

variable "rede_vpc_priv_cidr" {
  type      = string
  default   = "20.0.0.0/16"
}

variable "subnet_priv_cidr" {
    type        = string
    default     = "20.0.1.0/24"
}