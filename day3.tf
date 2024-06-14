# terraform {
#   required_providers {
#     azurerm = {
#       source = "hashicorp/azurerm"
#       version = "3.96.0"
#     }
#   }
# }

# provider "azurerm" {
#   features {
#     key_vault {
#     purge_soft_delete_on_destroy    = true
#     recover_soft_deleted_key_vaults = true
#     }
#   }
# }
# //azurerm = quel provider
# resource "azurerm_resource_group" "rg" { //nom du groupe dans terraform, une fois déployé on ne peut pas changer le nom
#   name     = "mathist" 
#   location = "West Europe"
# }
# #deployer un keyvault


# //datasource permettant d'appeler les ressources des utilisateurs
# data "azurerm_client_config" "current" {

# }

# resource "azurerm_key_vault" "kv" {
#   name                = "${var.my_name}kv"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name //data.azure_client_config.PASMONRG.name
#   tenant_id           = data.azurerm_client_config.current.tenant_id //identifiant de l'AD
#   sku_name            = "standard"

#   access_policy {
#     tenant_id = data.azurerm_client_config.current.tenant_id
#     object_id = data.azurerm_client_config.current.object_id //identifiant de l'utilisateur

# #Deployer un secret dans le keyvault en terraform
#     key_permissions = [
#       "Create",
#       "Get",
#       "List"
#     ]

#     secret_permissions = [
#       "Set",
#       "Get",
#       "Delete",
#       "Purge",
#       "Recover",
#       "List"
#     ]
#   }
# }

# resource "azurerm_key_vault_secret" "kvsecret1" {
#   name         = "secret-sauce"
#   value        = random_password.password.result
#   key_vault_id = azurerm_key_vault.kv.id
# }


# #Générer un mdp aléatoire et le mettre dans value du secret

# resource "random_password" "password" {
#   length           = 16
#   special          = true
#   override_special = "!#$%&*()-_=+[]{}<>:?"
# }

# #Deployer un mssql server avec votre mdp securise en password

# resource "azurerm_mssql_server" "sqlsrv" {
#   name                         = "mathistsqlsrv"
#   resource_group_name          = azurerm_resource_group.rg.name
#   location                     = "West US"
#   version                      = "12.0"
#   administrator_login          = "missadministrator"
#   administrator_login_password = random_password.password.result
#   minimum_tls_version          = "1.2"

#   azuread_administrator {
#     login_username = "AzureAD Admin"
#     object_id      = data.azurerm_client_config.current.object_id
#   }
# }



# #deployer une mssql database sur votre mssql server "sku_name = "GP_Gen5_2"


# resource "azurerm_mssql_database" "db" {
#   name           = "mathist-db"
#   server_id      = azurerm_mssql_server.sqlsrv.id
#   collation      = "SQL_Latin1_General_CP1_CI_AS"
#   max_size_gb    = 4
#   read_scale     = false
#   sku_name       = "GP_S_Gen5_2"
#   min_capacity   = 1 
#   auto_pause_delay_in_minutes = 60
#   enclave_type   = "VBS"
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

# resource "azurerm_resource_group" "rg-map" {
#     for_each = var.map_rg
#     name     = each.value.name
#     location = each.value.location
  
# }


# #deployer dans le rg west europe de votre foreach un vnet et 3 subnet
# #pour les subnet, utiliser count ou foreach


# resource "azurerm_virtual_network" "vnet" {
#   name                = "${var.my_name}-vnet"
#   location            = azurerm_resource_group.map_rg["rg1"].location
#   resource_group_name = azurerm_resource_group.map_rg["rg1"].name
#   address_space       = ["10.0.0.0/16"]

# }
# resource "azurerm_subnet" "subnet" {
#   count                = 3
#   name                 = "${var.my_name}-subnet${count.index}"
#   resource_group_name  = azurerm_resource_group.map_rg["rg1"].name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.${count.index}.0/24"]


  
# }

# #Deployer une vm dans le subnet 2
# #trouver un moyen de se connecter à la vm


# resource "azurerm_network_interface" "net-interface" {
#   name                = "${var.my_name}-netinterface"
#   location            = azurerm_resource_group.map_rg["rg1"].location
#   resource_group_name = azurerm_resource_group.map_rg["rg1"].name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.subnet[1].id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_linux_virtual_machine" "vm" {
#   name                = "${var.my_name}vm"
#   resource_group_name = azurerm_resource_group.map_rg["rg1"].name
#   location            = azurerm_resource_group.map_rg["rg1"].location
#   size                = "Standard_DS1_v2"
#   admin_username      = "adminuser"
#   disable_password_authentication = true
#   network_interface_ids = [
#     azurerm_network_interface.net-interface.id,
#   ]
#     admin_ssh_key {
#     username   = "adminuser"
#     public_key = file("C:/Users/Mathis/.ssh/id_ed25519.pub")
#   }
  
#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }
#     source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts"
#     version   = "latest"
#   }

# }