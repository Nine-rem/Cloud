/*Espace sécurisé per*/

resource "azurerm_key_vault" "kv" {
  name                = "${var.my_name}kv"
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

resource "azurerm_key_vault_secret" "kvsecret1" {
  name         = "MTSECRET"
  value        = random_password.password[0].result
  key_vault_id = azurerm_key_vault.kv.id
}