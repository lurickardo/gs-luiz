module "rede" {
    source              = "./module/rede"
    rede_vpc_pub_cidr   = var.rede_vpc_pub_cidr
    rede_vpc_priv_cidr  = var.rede_vpc_priv_cidr
    subnet_pub_cidr     = var.subnet_pub_cidr
    subnet_priv_cidr    = var.subnet_priv_cidr
}

module "compute" {
    source                  = "./module/compute"
    rede_vpc_id             = module.rede.rede_vpc_id
    rede_vpc_pub_cidr       = module.rede.rede_vpc_pub_cidr
    rede_vpc_priv_cidr      = module.rede.rede_vpc_priv_cidr
    rede_subnet_1_id        = module.rede.rede_subnet_1_id
    rede_subnet_2_id        = module.rede.rede_subnet_2_id
    compute_image_id        = var.compute_image_id
    compute_instance_type   = var.compute_instance_type
    compute_key_name        = var.compute_image_id
}