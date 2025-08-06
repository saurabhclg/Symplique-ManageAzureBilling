variable "function_app_name" {
  description = "The name of the Azure Function App"
  type        = string
}

variable "location" {
  description = "Azure region for the Function App"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group where Function App will be deployed"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account used by the Function App"
  type        = string
}

variable "storage_container_name" {
  description = "Name of the container in storage account to hold function app ZIP package"
  type        = string
  default     = "function-code"
}

variable "source_code_path" {
  description = "Path to the zipped Function App code for deployment"
  type        = string
}

variable "cosmosdb_connection_string" {
  description = "Cosmos DB connection string for use in function app"
  type        = string
  sensitive   = true
}

variable "blob_connection_string" {
  description = "Azure Storage Blob connection string"
  type        = string
  sensitive   = true
}

variable "threshold_days" {
  description = "Days threshold for archival logic"
  type        = number
  default     = 90
}

variable "tags" {
  description = "Tags to assign to resources"
  type        = map(string)
  default     = {}
}

