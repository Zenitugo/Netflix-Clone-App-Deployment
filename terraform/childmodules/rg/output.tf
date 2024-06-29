# Output the location of the resource group
output "rg-location" {
  value = azurerm_resource_group.rg.location
}



################################################################################
################################################################################


# Output the name of the resource-group
output "rg-name" {
  value = azurerm_resource_group.rg.name
}


#################################################################################
#################################################################################

# Output the id of the resource-group
output "rg-id" {
  value = azurerm_resource_group.rg.id
}