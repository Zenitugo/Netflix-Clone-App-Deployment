# Create a kubernetes cluster in Azure Kubernetes Service

resource "azurerm_kubernetes_cluster" "cluster" {
  name                           = "${var.name}-${var.env}-cluster"
  location                       = var.rg-location
  resource_group_name            = var.rg-name
  dns_prefix                     = "devaks1"

  kubernetes_version             = var.kubernetes_version 
  node_resource_group            = var.node-group-name
  private_cluster_enabled        = false
  automatic_channel_upgrade      = "none"


  sku_tier                       = var.sku_tier

  oidc_issuer_enabled            = true
  workload_identity_enabled      = true

  network_profile {
    network_plugin               = "azure" 
    dns_service_ip               = var.dns_service_ip
    service_cidr                 =  var.service_cidr
  }

  default_node_pool {
    name                         = "general"
    vm_size                      = "Standard_D2_v2"
    vnet_subnet_id               = var.pri-sub
    orchestrator_version         = var.kubernetes_version
    type                         = "VirtualMachineScaleSets"
    enable_auto_scaling          = true  
    node_count                   = 1
    min_count                    = 1
    max_count                    = 2  
  }

  identity {
    type                         = "UserAssigned"
    identity_ids                 = [var.user-id] 
  }

  tags = {
    Environment = var.env
  }

  depends_on = [ var.user-role ]
}


################################################################################################################
################################################################################################################


# Create Nodes for the AKS cluster

resource "azurerm_kubernetes_cluster_node_pool" "aks-nodes" {
  name                  = "${var.name}-nodes"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1
  vnet_subnet_id        = var.pri-sub 
  orchestrator_version  = var.kubernetes_version 

  enable_auto_scaling          = true
  min_count                    = 1
  max_count                    = 2  

  tags = {
    Environment = "Production"
  }
}