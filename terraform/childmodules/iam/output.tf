# Output the user identity id
output "user-id" {
    value   = azurerm_user_assigned_identity.identity.id
}


#################################################
#################################################

# Output the role of the user
output "user-role" {
    value   = azurerm_role_assignment.user-role.id
}