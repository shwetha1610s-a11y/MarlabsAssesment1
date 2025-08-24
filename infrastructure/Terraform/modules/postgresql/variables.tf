variable "name" {}
variable "resource_group_name" {}
variable "location" {}
variable "administrator_login" {}
variable "administrator_password" {}
variable "sku_name" { default = "B_Standard_B1ms" }
variable "storage_mb" { default = 32768 }
variable "version" { default = "13" }
variable "zone" { default = "1" }