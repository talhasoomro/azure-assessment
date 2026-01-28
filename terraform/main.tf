terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.75"
    }
  }
  
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "tfstatetalha2024"  
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-webapp-${var.environment}"
  location = var.location
  
  tags = {
    Environment = var.environment
    Project     = "CloudAssessment"
    Owner       = "Talha"
    ManagedBy   = "Terraform"
  }
}
