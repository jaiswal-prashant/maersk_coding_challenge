resource "azurerm_storage_account" "storage_account" {
  for_each                 = var.storage_account_name      
  name                     = each.key
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
  account_kind              = each.value.account_kind
  access_tier               = each.value.access_tier
  enable_https_traffic_only = each.value.enable_https_traffic_only
  allow_blob_public_access  = each.value.allow_blob_public_access
  blob_properties {
    delete_retention_policy {
      days = each.value.delete_retention_policy
    }
    container_delete_retention_policy {
      days = each.value.container_delete_retention_policy
    }
    versioning_enabled = each.value.versioning_enabled
  } 

  min_tls_version          = each.value.min_tls_version
  tags = each.value.tags

}

resource "azurerm_storage_container" "container_name" {
  for_each              = var.storage_account_name 
  name                  = each.value.container_name
  storage_account_name  = azurerm_storage_account.storage_account[each.key].name
  container_access_type = each.value.container_access_type
}