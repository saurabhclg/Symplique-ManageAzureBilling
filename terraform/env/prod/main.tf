provider "azurerm" {
  features = {}
}

module "cosmosdb" {
  source              = "../../modules/cosmosdb"
  account_name        = "prod-cosmosdb"    # replace per env
  location            = "west-europe"
  resource_group      = "database-nonprod"
  database_name       = "billingdb"
  container_name      = "billingrecords"
}

module "blobstorage" {
  source                = "../../modules/blobstorage"
  storage_account_name  = "prodstorageacct" # replace per env
  container_name        = "archive"
  location              = "west-europe"
  resource_group_name   = "storageaccount-nonprod"
}

module "keyvault" {
  source = "../../modules/keyvault"
  keyvault_name = "prod-kv"
  location = "west-europe"
  resource_group_name = "keyvault-nonprod"
}

module "functions" {
  source                         = "../../modules/functions"
  function_app_name              = "int-fn-billing"
  location                       = "west-europe"
  resource_group_name            = "functionapp-nonprod"
  storage_account_name           = module.blobstorage.storage_account_name
  storage_container_name         = "function-code"
  source_code_path               = "${path.module}/../../function.zip"  # Path to zipped functions
  cosmosdb_connection_string     = "AccountEndpoint=https://prod-cosmosdb.documents.azure.com:443/;AccountKey=prodDummyKey1234567890==;Database=prod-billingdb;"
  blob_connection_string         = "DefaultEndpointsProtocol=https;AccountName=prodstorageacct;AccountKey=prodStorageDummyKey1234567890==;EndpointSuffix=core.windows.net"
  threshold_days                 = "20"
  tags                           = {
    environment = "nonprod"
    owner       = "symplique"
  }
}
