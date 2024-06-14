
# //azurerm = quel provider
# resource "azurerm_resource_group" "rg" { //nom du groupe dans terraform, une fois déployé on ne peut pas changer le nom
#   name     = "mathist" 
#   location = "West Europe"
# }

# resource "azurerm_resource_group" "map_rg" {
#     for_each = var.all_rg
#     name     = each.value.name
#     location = each.value.location
  
# }



# #rajouter des variables das le code 
# #creer une variable map pour deployer 3 ressourcegroup, West Europe, West US, East US
# #utiliser for_each pour deployer les ressources

# /*
# variable "map_rg" {
#     type = map
#     default = {
#         "West Europe" = "mathist-WestEU"
#         "West US" = "mathist-WestUS"
#         "East US" = "mathist-EastUS"
#     }
  
# }

# resource "azurerm_resource_group" "rg-map" {
#   for_each = var.map_rg
#   name     = each.value
#   location = each.key
# }

# */


# #Deployer une vm dans le subnet 2
# #trouver un moyen de se connecter à la vm


# resource "azurerm_linux_virtual_machine" "linvm" {
#   name                = "vmlinux-${var.my_name}"
#   resource_group_name = azurerm_resource_group.map_rg["rg1"].name
#   location            = azurerm_resource_group.map_rg["rg1"].location
#   size                = "Standard_DS2_v2"
#   admin_username      = "adminuser"
#   admin_password = random_password.password[2].result
#   network_interface_ids = [
#     azurerm_network_interface.net-interface.id,
#   ]

#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = file("~/.ssh/id_rsa.pub")
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts"
#     version   = "latest"
#   }
# }

# #Deployer grafana dashboard
# #vous connecter a grafana pour voir les metrics du keyvault


# resource "azurerm_dashboard_grafana" "grafana" {
#   name                              = "${var.my_name}-grafana"
#   resource_group_name               = azurerm_resource_group.map_rg["rg1"].name
#   location                          = azurerm_resource_group.map_rg["rg1"].location
#   api_key_enabled                   = true
#   deterministic_outbound_ip_enabled = true
#   public_network_access_enabled     = true

#   identity {
#     type = "SystemAssigned"
#   }

#   tags = {
#     key = "value"
#   }
# }




# /* correction */

# resource "azurerm_dashboard_grafana" "grafana" {
#   name                              = "raph-grafana"
#   resource_group_name               = azurerm_resource_group.all_rg["rg1"].name
#   location                          = "West Europe"
#   api_key_enabled                   = true
#   deterministic_outbound_ip_enabled = true
#   public_network_access_enabled     = true

#   identity {
#     type = "SystemAssigned"
#   }
# }
# resource "azurerm_role_assignment" "grafana_permission" {
#   role_definition_name = "Monitoring Reader"
#   scope                = data.azurerm_subscription.primary.id
#   principal_id         = azurerm_dashboard_grafana.grafana.identity[0].principal_id
# }
# resource "azurerm_role_assignment" "my_user_permission" {
#   role_definition_name = "Grafana Admin"
#   scope                = azurerm_dashboard_grafana.grafana.id
#   principal_id         = data.azurerm_client_config.current.object_id
# }