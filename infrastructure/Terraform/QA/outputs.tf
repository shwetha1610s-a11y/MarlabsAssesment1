output "frontend_app_service_id" {
  value = module.frontend_app_service.id
}

output "backend_app_service_id" {
  value = module.backend_app_service.id
}

output "postgresql_id" {
  value = module.postgresql.id
}

output "storage_id" {
  value = module.storage.id
}

output "key_vault_id" {
  value = module.key_vault.id
}

output "app_insights_id" {
  value = module.app_insights.id
}

output "aks_id" {
  value = module.aks.id
}

output "aks_kube_config" {
  value     = module.aks.kube_config
  sensitive = true
}