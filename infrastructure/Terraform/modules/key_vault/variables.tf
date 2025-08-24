variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "tenant_id" {}
variable "sku_name" { default = "standard" }
variable "soft_delete_enabled" { default = true }
variable "purge_protection_enabled" { default = true }
variable "enabled_for_deployment" { default = true }
variable "enabled_for_disk_encryption" { default = true }
variable "enabled_for_template_deployment" { default = true }