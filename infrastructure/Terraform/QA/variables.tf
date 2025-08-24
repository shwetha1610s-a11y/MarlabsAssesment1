variable "resource_group_name" {
  description = "Name of the resource group."
}

variable "location" {
  description = "Azure region for resources."
}

variable "prefix" {
  description = "Prefix for resource naming."
}

variable "db_admin" {
  description = "PostgreSQL admin username."
}

variable "db_password" {
  description = "PostgreSQL admin password (initial, will be stored in Key Vault)."
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure AD tenant ID."
}

variable "pricing_tier" {
  description = "The pricing tier for the App Service Plan (e.g., Standard, Premium)."
  type        = string
  default     = "Standard"
}

variable "pricing_size" {
  description = "The size for the App Service Plan (e.g., S1, P1V2)."
  type        = string
  default     = "S1"
}