terraform {
  backend "azurerm" {
    resource_group_name  = "storageaccount"
    storage_account_name = "terraformbackend12"
    container_name       = "task3"
    key                  = "terraform.workspace"
  }
}