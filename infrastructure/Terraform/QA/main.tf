terraform {
  backend "azurerm" {
    resource_group_name  = "<YOUR-STATE-RG>"
    storage_account_name = "<YOURSTATESTORAGE>"
    container_name       = "tfstate"
    key                  = "qa.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "qa_rg" {
  name     = var.resource_group_name
  location = var.location
}

data "azurerm_resource_group" "qa_rg" {
  name = var.resource_group_name
  location = var.location
}

module "app_service_plan" {
  source              = "../modules/app_service_plan"
  name                = "${var.prefix}-asp"
  location            = data.azurerm_resource_group.qa_rg.location
  resource_group_name = data.azurerm_resource_group.qa_rg.name
  kind                = "Linux"
  reserved            = true
  sku_tier            = var.pricing_tier
  sku_size            = var.pricing_size
}

module "key_vault" {
  source              = "../modules/key_vault"
  name                = "${var.prefix}-kv"
  location            = azurerm_resource_group.qa_rg.location
  resource_group_name = azurerm_resource_group.qa_rg.name
  tenant_id           = var.tenant_id
}

resource "azurerm_key_vault_secret" "db_password" {
  name         = "db-password"
  value        = var.db_password
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_secret" "db_password" {
  name         = azurerm_key_vault_secret.db_password.name
  key_vault_id = module.key_vault.id
}

module "frontend_app_service" {
  source              = "../modules/app_service"
  name                = "${var.prefix}-frontend"
  location            = data.azurerm_resource_group.qa_rg.location
  resource_group_name = data.azurerm_resource_group.qa_rg.name
  app_service_plan_id = module.app_service_plan.id
  linux_fx_version    = "NODE|18-lts"
  app_settings        = { "ANGULAR_ENV" = "qa" }
  pricing_tier        = var.pricing_tier
  pricing_size        = var.pricing_size
}

module "backend_app_service" {
  source              = "../modules/app_service"
  name                = "${var.prefix}-backend"
  location            = data.azurerm_resource_group.qa_rg.location
  resource_group_name = data.azurerm_resource_group.qa_rg.name
  app_service_plan_id = module.app_service_plan.id
  linux_fx_version    = "DOTNETCORE|8.0"
  app_settings        = { "ASPNETCORE_ENVIRONMENT" = "QA" }
  pricing_tier        = var.pricing_tier
  pricing_size        = var.pricing_size
}

module "postgresql" {
  source                  = "../modules/postgresql"
  name                    = "${var.prefix}-pg"
  location                = azurerm_resource_group.qa_rg.location
  resource_group_name     = azurerm_resource_group.qa_rg.name
  administrator_login     = var.db_admin
  administrator_password  = data.azurerm_key_vault_secret.db_password.value
}

module "storage" {
  source              = "../modules/storage"
  name                = lower(replace("${var.prefix}storageqa", "-", ""))
  location            = azurerm_resource_group.qa_rg.location
  resource_group_name = azurerm_resource_group.qa_rg.name
}

module "app_insights" {
  source              = "../modules/app_insights"
  name                = "${var.prefix}-ai"
  location            = azurerm_resource_group.qa_rg.location
  resource_group_name = azurerm_resource_group.qa_rg.name
}
module "aks" {
  source              = "../modules/aks"
  name                = "${var.prefix}-aks"
  location            = data.azurerm_resource_group.qa_rg.location
  resource_group_name = data.azurerm_resource_group.qa_rg.name
  dns_prefix          = "${var.prefix}-aks"
  node_count          = var.aks_node_count
  vm_size             = var.aks_vm_size
  kubernetes_version  = var.aks_kubernetes_version
}