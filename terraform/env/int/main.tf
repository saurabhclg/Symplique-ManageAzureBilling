provider "azurerm" {
  features = {}
}

module "cosmosdb" {
  source              = "../../modules/cosmosdb"
  account_name        = "prod-cosmosdb"
  location            = "west-europe"
  resource_group      = "prod-resource-group"
  database_name       = "prod-billingdb"
  container_name      = "prod-billingrecords"
}

module "blobstorage" {
  source                = "../../modules/blobstorage"
  storage_account_name  = "prodstorageacct"
  container_name        = "prod-archive"
  location              = "west-europe"
  resource_group_name   = "prod-resource-group"
}

module "keyvault" {
  source                = "../../modules/keyvault"
  keyvault_name         = "prod-kv"
  location              = "west-europe"
  resource_group_name   = "prod-resource-group"
  tenant_id             = "00000000-0000-0000-0000-000000000000"
}

module "functions" {
  source                         = "../../modules/functions"
  function_app_name              = "prod-fn-billing"
  location                       = "west-europe"
  resource_group_name            = "prod-resource-group"
  storage_account_name           = module.blobstorage.storage_account_name
  storage_container_name         = "function-code"
  source_code_path               = "${path.module}/../../function.zip"
  cosmosdb_connection_string     = "AccountEndpoint=https://prod-cosmosdb.documents.azure.com:443/;AccountKey=prodDummyKey1234567890==;Database=prod-billingdb;"
  blob_connection_string         = "DefaultEndpointsProtocol=https;AccountName=prodstorageacct;AccountKey=prodStorageDummyKey1234567890==;EndpointSuffix=core.windows.net"
  threshold_days                 = 30
  tags                           = {
    environment = "prod"
    owner       = "dummy
  }
}