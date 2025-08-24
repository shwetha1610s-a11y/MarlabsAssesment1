resource_group_name = "qa-blogapp-rg"
location           = "East US"
prefix             = "qa-blogapp"
db_admin           = "pgadmin"
#db_password and tenant_id are injected from Azure DevOps variable group linked to Key Vault
db_password        = ""
tenant_id          = ""
pricing_tier       = "Standard"
pricing_size       = "S1"
aks_node_count        = 1
aks_vm_size           = "Standard_DS2_v2"
aks_kubernetes_version = "1.29.2"