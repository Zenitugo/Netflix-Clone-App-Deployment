# Output private subnet id
output "pri-sub" {
    value = azurerm_subnet.pri-subnet.id
}