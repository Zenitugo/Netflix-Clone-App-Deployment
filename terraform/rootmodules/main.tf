# Module of each resource

module "rg" {
    source                          = "../childmodules/rg"
    name                            = var.name
    location                        = var.location
}


module "vnet" {
    source                          = "../childmodules/vnet"
    name                            = var.name
    rg-location                     = module.rg.rg-location
    rg-name                         = module.rg.rg-name 
    env                             = var.env
    address_space                   = var.address_space 
    address_prefixes1               = var.address_prefixes1 
    address_prefixes2               = var.address_prefixes2 
}

module "iam" {
    source                         = "../childmodules/iam"
    rg-location                    = module.rg.rg-location
    rg-name                        = module.rg.rg-name 
    identity                       = var.identity 
    rg-id                          = module.rg.rg-id 
}


module "aks" {
    source                        = "../childmodules/aks"
    name                          = var.name 
    rg-name                       = module.rg.rg-name
    rg-location                   = module.rg.rg-location
    env                           = var.env
    kubernetes_version            = var.kubernetes_version 
    node-group-name               = var.node-group-name 
    sku_tier                      = var.sku_tier 
    service_cidr                  = var.service_cidr 
    dns_service_ip                = var.dns_service_ip 
    pri-sub                       = module.vnet.pri-sub 
    user-id                       = module.iam.user-id 
    user-role                     = module.iam.user-role  
    
}


