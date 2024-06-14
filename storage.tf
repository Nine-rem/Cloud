
# #Deployer un mssql server avec votre mdp securise en password

# resource "azurerm_mssql_server" "sqlsrv" {
#   name                         = "mathistsqlsrv"
#   resource_group_name          = azurerm_resource_group.rg.name
#   location                     = "West US"
#   version                      = "12.0"
#   administrator_login          = "missadministrator"
#   administrator_login_password = random_password.password[1].result
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

