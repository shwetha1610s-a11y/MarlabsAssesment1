variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "app_service_plan_id" {}
variable "linux_fx_version" {}
variable "app_settings" { type = map(string) }