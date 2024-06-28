# Create a virtual network in Azure Cloud Provider
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name}-vnet"
  location            = var.rg-location
  resource_group_name = var.rg-name
  address_space       = var.address_space
  



  tags = {
    environment = var.env
  }
}


############################################################################################
############################################################################################

# Create subnets for the virtual network

# private subnet on vnet
resource "azurerm_subnet" "pri-subnet" {
  name                 = "${var.name}-prisub"
  resource_group_name  = var.rg-name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.address_prefixes1

}


#Public subnet on vnet
resource "azurerm_subnet" "pub-subnet" {
  name                 = "${var.name}-pubsub"
  resource_group_name  = var.rg-name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.address_prefixes2

}


# There is no need to create internet gateway and nat gateway. They are available by default.