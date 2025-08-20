output "app_service_url"
{
  value = azurerm_app_service.blog_app.default_site_hostname
}
