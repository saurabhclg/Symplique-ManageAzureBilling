variable "keyvault_name" {
  description = "The name of the Azure Key Vault"
  type        = string
}

variable "location" {
  description = "Azure region for the Key Vault"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group for the Key Vault"
  type        = string
}

variable "tenant_id" {
  description = "Azure Active Directory tenant ID"
  type