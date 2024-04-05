
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

# resource "azurerm_storage_account" "rg" {
#   name                     = "storageaccountmathist"
#   resource_group_name      = azurerm_resource_group.rg.name
#   location                 = azurerm_resource_group.rg.location
#   account_tier             = "Standard"
#   access_tier              = "Cool"
#   account_replication_type = "GRS"

#   tags = {
#     environment = "staging"
#   }
# }
# //conteneur dans la baie de stockage
# resource "azurerm_storage_container" "container" {
#   name                  = "containermathist"
#   storage_account_name  = azurerm_storage_account.rg.name
#   container_access_type = "private"
# }

# #déployer un sas token

# data "azurerm_storage_account_sas" "stosas" {
#   connection_string = azurerm_storage_account.rg.primary_connection_string
#   https_only        = true
#   signed_version    = "2024-03-15"

#   resource_types {
#     service   = true
#     container = false
#     object    = false
#   }

#   services {
#     blob  = true
#     queue = false
#     table = false
#     file  = false
#   }

#   start  = "2024-03-15T00:00:00Z"
#   expiry = "2024-03-16T00:00:00Z"

#   permissions {
#     read    = true
#     write   = true
#     delete  = false
#     list    = false
#     add     = true
#     create  = true
#     update  = false
#     process = false
#     tag     = false
#     filter  = false
#   }
# }

# #deployer un keyvault


# //datasource permettant d'appeler les ressources des utilisateurs
# data "azurerm_client_config" "current" {

# }
# /*
# data "azurerm_resource_group" "PASMONRG"{
#   name           =        "notmyrg"
  
# }*/

# resource "azurerm_key_vault" "key" {
#   name                = "keyvaultmathist"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name //data.azure_client_config.PASMONRG.name
#   tenant_id           = data.azurerm_client_config.current.tenant_id //identifiant de l'AD
#   sku_name            = "standard"

#   access_policy {
#     tenant_id = data.azurerm_client_config.current.tenant_id
#     object_id = data.azurerm_client_config.current.object_id //identifiant de l'utilisateur
#   }
# }
