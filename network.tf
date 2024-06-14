
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

# resource "azurerm_network_interface" "net-interface" {
#   name                = "${var.my_name}-netinterface"
#   location            = azurerm_resource_group.map_rg["rg1"].location
#   resource_group_name = azurerm_resource_group.map_rg["rg1"].name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.subnet[1].id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id = azurerm_public_ip.vmip.id
#   }
# }

# resource "azurerm_public_ip" "vmip" {
#     name                = "${var.my_name}-publicip"
#     location            = azurerm_resource_group.map_rg["rg1"].location
#     resource_group_name = azurerm_resource_group.map_rg["rg1"].name
#     allocation_method   = "Dynamic"
  
# }