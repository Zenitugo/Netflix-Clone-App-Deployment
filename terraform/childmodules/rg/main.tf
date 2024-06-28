
# Create a resource group for the Netflix Project
resource "azurerm_resource_group" "rg" {
  name     = "${var.name}-rg"
  location = var.location 
}