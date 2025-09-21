terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.41.0"
    }
  }
}

provider "azurerm" {

  features {}

subscription_id =   "f0c6c28a-7429-42b3-aefa-63439e20a651"

}



