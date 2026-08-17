terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0" # Changed to standard '~>' pessimistic operator
    }
  }
}

provider "azurerm" {
  features {}
}