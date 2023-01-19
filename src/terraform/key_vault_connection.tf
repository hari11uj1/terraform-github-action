terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.39.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

terraform {
  backend "remote" {
    organization = "SNOWFLAKE_TERRAFORM_INTIGRATION"

    workspaces {
      name = "SNOWFLAKE_TERAFORM"
    }
  }
}

provider "snowflake" {
 username = var.snowflake_username
 account = var.snowflake_account
 role = var.snowflake_role
} 


provider "azurerm" {
  features {}

  subscription_id   = "f2ca2eec-9923-4431-adc8-9bb426060e2e"
  tenant_id         = "6d0bcd9c-6b7d-4bef-ab75-53911e0b2109"
  client_id         = "e3bbbc2c-da9f-4609-95e4-26237ee1b568"
  client_secret     = ".2T8Q~eK7Aj081EAXhg0ZmvuUel5w6QCqJ6uGbPs"
}



data "azurerm_key_vault" "azvault" {
  name                = "CICDTestKVRaj"
  resource_group_name = "CICD_Kroger_Raj_RG"

}

data "azurerm_key_vault_secret" "secert" {
  name         = "tf-snowflake-account"
  key_vault_id = data.azurerm_key_vault.azvault.id
}

output "secret_value" {
  value = data.azurerm_key_vault_secret.secret.value
}