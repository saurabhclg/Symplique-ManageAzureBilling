provider "azurerm" {
  features = {}
}

module "cosmosdb" {
  source              = "../../modules/cosmosdb"
  account_name        = "prod-cosmosdb"    # replace per env
  location            = var.location
  resource_group      = var.resource_group_name
  database_name       = "billingdb"
  container_name      = "billingrecords"
}

module "blobstorage" {
  source                = "../../modules/blobstorage"
  storage_account_name  = "prodstorageacct" # replace per env
  container_name        = "archive"
  location              = var.location
  resource_group_name   = var.resource_group_name
}

module "keyvault" {
  source = "../../modules/keyvault"
  keyvault_name = "prod-kv"
  location = var.location
  resource_group_name = var.resource_group_name
  tenant_id = var.tenant_id
}

module "functions" {
  source                         = "../../modules/functions"
  function_app_name              = var.function_app_name         # e.g. "prod-fn-billing"
  location                       = var.location
  resource_group_name            = var.resource_group_name
  storage_account_name           = module.blobstorage.storage_account_name
  storage_container_name         = "function-code"
  source_code_path               = "${path.module}/../../function.zip"  # Path to zipped functions
  cosmosdb_connection_string     = var.cosmosdb_connection_string
  blob_connection_string         = var.blob_connection_string
  threshold_days                 = var.threshold_days
  tags                           = var.tags
}
