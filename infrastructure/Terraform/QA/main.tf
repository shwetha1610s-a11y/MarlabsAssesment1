provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "blog_rg" {
  name     = "blog-app-rg"
  location = "East US"
}

resource "azurerm_app_service_plan" "blog_plan" {
  name                = "blog-app-plan"
  location            = azurerm_resource_group.blog_rg.location
  resource_group_name = azurerm_resource_group.blog_rg.name
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "blog_app" {
  name                = "blog-app-service"
  location            = azurerm_resource_group.blog_rg.location
  resource_group_name = azurerm_resource_group.blog_rg.name
  app_service_plan_id = azurerm_app_service_plan.blog_plan.id

  site_config {
    always_on = true
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.blog_insights.instrumentation_key
    "COSMOS_DB_CONN_STRING"          = azurerm_cosmosdb_account.blog_cosmos.connection_strings[0]
  }
}

resource "azurerm_application_insights" "blog_insights" {
  name                = "blog-app-insights"
  location            = azurerm_resource_group.blog_rg.location
  resource_group_name = azurerm_resource_group.blog_rg.name
  application_type    = "web"
}

resource "azurerm_cosmosdb_account" "blog_cosmos" {
  name                = "blog-cosmos-db"
  location            = azurerm_resource_group.blog_rg.location
  resource_group_name = azurerm_resource_group.blog_rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.blog_rg.location
    failover_priority = 0
  }
}

resource "azurerm_key_vault" "blog_kv" {
  name                = "blog-keyvault"
  location            = azurerm_resource_group.blog_rg.location
  resource_group_name = azurerm_resource_group.blog_rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

data "azurerm_client_config" "current" {}
