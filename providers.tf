provider "azurerm" {
  features {}

  # More information on the authentication methods supported by
  # the AzureRM Provider can be found here:
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

  # subscription_id = "..."
  # client_id       = "..."
  # client_secret   = "..."
  # tenant_id       = "..."
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.4.0"
      # version = "~>4.0"
    }
  }
  # terraform version
  required_version = "~>1.5.0"
}
