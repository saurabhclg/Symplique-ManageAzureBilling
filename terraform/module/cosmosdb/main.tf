resource "azurerm_cosmosdb_account" "cosmos" {
  name                = var.account_name
  location            = var.location
  resource_group_name = var.resource_group
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  consistency_policy {
    consistency_level = "Session"
  }
  geo_location {
    location          = var.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "db" {
  name           = var.database_name
  account_name   = azurerm_cosmosdb_account.cosmos.name
  resource_group_name = var.resource_group
}

resource "azurerm_cosmosdb_sql_container" "container" {
  name                = var.container_name
  resource_group_name = var.resource_group
  account_name        = azurerm_cosmosdb_account.cosmos.name
  database_name       = azurerm_cosmosdb_sql_database.db.name
  partition_key_path  = "/partitionKey"
  throughput          = var.throughput
}

