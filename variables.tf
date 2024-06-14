variable "my_name"{
    type = string
    default = "mathist"

}
/*
variable "map_rg" {
    type = map
    default = {
        "West Europe" = "mathist-WestEU"
        "West US" = "mathist-WestUS"
        "East US" = "mathist-EastUS"
    }
  
}

resource "azurerm_resource_group" "rg-map" {
  for_each = var.map_rg
  name     = each.value
  location = each.key
}

*/
# //correction
# variable "all_rg" {
#     type = map
#     default = {
#         "rg1" = {
#             name = "mathistrg1"
#             location = "West Europe"
#         },
#         "rg2" = {
#             name = "mathistrg2"
#             location = "West US"
#         },
#         "rg3" = {
#             name = "mathistrg3"
#             location = "East US"
#         }
#     }
  
# }