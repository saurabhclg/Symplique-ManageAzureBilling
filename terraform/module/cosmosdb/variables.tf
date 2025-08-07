variable "account_name" {
  description = "The name of the Azure Cosmos DB account"
  type        = string
}

variable "database_name" {
  description = "The name of the Cosmos DB database"
  type        = string
}

variable "container_name" {
  description = "The name of the Cosmos DB container"
  type        = string
}

variable "location" {
  description = "Azure region for the Cosmos DB account"
  type        = string
}

variable "resource_group" {
  description = "Name of the resource group for Cosmos DB"
  type        = string
}

variable "throughput" {
  description = "Provisioned throughput for the Cosmos DB container"
  type        = number
  default     = 400
}

variable "tags" {
  description = "Tags to assign to Cosmos DB resources"
  type        = map(string)
  default     =

