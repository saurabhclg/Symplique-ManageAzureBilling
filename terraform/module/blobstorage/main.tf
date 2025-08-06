resource "azurerm_storage_account" "blob" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  enable_https_traffic_only = true
}

resource "azurerm_storage_container" "archive" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.blob.name
  container_access_type = "private"
}

