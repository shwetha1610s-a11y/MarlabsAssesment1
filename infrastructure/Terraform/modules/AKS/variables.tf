variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "dns_prefix" {}
variable "node_count" { default = 1 }
variable "vm_size" { default = "Standard_DS2_v2" }
variable "kubernetes_version" { default = "1.29.2" }