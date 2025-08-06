resource "azurerm_resource_group" "rg" {
  # Optional: if you want resource group creation here, otherwise pass existing RG ID/name
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "function_storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  enable_https_traffic_only = true
}

resource "azurerm_storage_container" "function_zip_container" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.function_storage.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "function_app_zip" {
  name                   = "${var.function_app_name}.zip"
  storage_account_name   = azurerm_storage_account.function_storage.name
  storage_container_name = azurerm_storage_container.function_zip_container.name
  type                   = "Block"
  source                 = var.source_code_path
}

resource "azurerm_app_service_plan" "function_plan" {
  name                = "${var.function_app_name}-plan"
  location            = var.location
  resource_group_name = var.resource_group_name

  kind     = "FunctionApp"
  reserved = true # required for Linux plans

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "function_app" {
  name                       = var.function_app_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = azurerm_app_service_plan.function_plan.id
  storage_account_name       = azurerm_storage_account.function_storage.name
  storage_account_access_key = azurerm_storage_account.function_storage.primary_access_key
  version                    = "~4" # Use latest supported runtime version, adjust as needed
  os_type                   = "linux"

  identity {
    type = "SystemAssigned"
  }

  site_config {
    linux_fx_version = "Python|3.9"
    application_stack {
      python_version = "3.9"
    }
    always_on = true
  }

  # Enable running function app from ZIP package
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = azurerm_storage_blob.function_app_zip.url
    "FUNCTIONS_EXTENSION_VERSION" = "~4"
    "FUNCTIONS_WORKER_RUNTIME"  = "python"

    # Your custom app settings variables
    "COSMOSDB_CONNECTION_STRING" = var.cosmosdb_connection_string
    "BLOB_STORAGE_CONNECTION_STRING" = var.blob_connection_string
    "THRESHOLD_DAYS" = var.threshold_days
  }

  tags = var.tags
}

