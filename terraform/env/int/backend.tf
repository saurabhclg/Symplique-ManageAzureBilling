terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "terraformstate123"   # Must be globally unique
    container_name       = "tfstate"
    key                  = "int.terraform.tfstate"  # State file name
  }
}

