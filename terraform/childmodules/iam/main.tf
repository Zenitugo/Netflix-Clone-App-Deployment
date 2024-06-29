# Create a user identity

resource "azurerm_user_assigned_identity" "identity" {
  location            = var.rg-location
  name                = var.identity
  resource_group_name = var.rg-name
}

#########################################################################
########################################################################

# Assign the user a role
resource "azurerm_role_assignment" "user-role" {
  scope                = var.rg-id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.identity.principal_id
}