#Registry Module
terraform {
  required_version = ">=1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.0"
    }
  }
}

#Provider Module
provider "azurerm" {
  skip_provider_registration = "true" #Optinally used (Error ensuring Resource Providers are registered.)
  features {}
}

