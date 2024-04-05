terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.96.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
    purge_soft_delete_on_destroy    = true
    recover_soft_deleted_key_vaults = true
    }
  }
}
//azurerm = quel provider
resource "azurerm_resource_group" "rg" { //nom du groupe dans terraform, une fois déployé on ne peut pas changer le nom
  name     = "mathist" 
  location = "West Europe"
}
#deployer un keyvault


//datasource permettant d'appeler les ressources des utilisateurs
data "azurerm_client_config" "current" {

}

resource "azurerm_key_vault" "kv" {
  name                = "mathistkv"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name //data.azure_client_config.PASMONRG.name
  tenant_id           = data.azurerm_client_config.current.tenant_id //identifiant de l'AD
  sku_name            = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id //identifiant de l'utilisateur

#Deployer un secret dans le keyvault en terraform
    key_permissions = [
      "Create",
      "Get",
      "List"
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover",
      "List"
    ]
  }
}

resource "azurerm_key_vault_secret" "kvsecret" {
  name         = "secret-sauce"
  value        = random_password.password.result
  key_vault_id = azurerm_key_vault.kv.id
}


#Générer un mdp aléatoire et le mettre dans value du secret

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

#Deployer un mssql server avec votre mdp securise en password

resource "azurerm_mssql_server" "sqlsrv" {
  name                         = "mathistsqlsrv"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = "West US"
  version                      = "12.0"
  administrator_login          = "missadministrator"
  administrator_login_password = random_password.password.result
  minimum_tls_version          = "1.2"

  azuread_administrator {
    login_username = "AzureAD Admin"
    object_id      = data.azurerm_client_config.current.object_id
  }
}



#deployer une mssql database sur votre mssql server "sku_name = "GP_Gen5_2"


resource "azurerm_mssql_database" "db" {
  name           = "mathist-db"
  server_id      = azurerm_mssql_server.sqlsrv.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 4
  read_scale     = false
  sku_name       = "GP_S_Gen5_2"
  min_capacity   = 1 
  auto_pause_delay_in_minutes = 60
  enclave_type   = "VBS"
}




#vous connecter sur le portail azure, aller sur votre mssql database et vous connecter sur votre datapaase depuis query


#deployer 3 ressources group en une seule fois
resource "azurerm_resource_group" "rgcount" {
  count = 3
  name = "mathist-${count.index}"
  location = "West Europe"
}



#deployer un storatge account dans votre premier resource group

resource "azurerm_storage_account" "rg" {
  name                     = "mathiststorage"
  resource_group_name      = azurerm_resource_group.rgcount[0].name
  location                 = azurerm_resource_group.rgcount[0].location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  access_tier = "Cool"
}