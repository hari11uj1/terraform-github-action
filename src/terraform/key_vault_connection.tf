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
  tenant_id         = "6d0bcd9c-6b7d-4bef-ab75-53911e0b2109"
  
}



/*data "azurerm_key_vault" "azvault" {
  name                = "CICDTestKVRaj"
  resource_group_name = "CICD_Kroger_Raj_RG"

}

data "azurerm_key_vault_secret" "secert" {
  name         = "tf-snowflake-account"
  key_vault_id = data.azurerm_key_vault.azvault.id
}

/*output "secret_value" {
  value = data.azurerm_key_vault_secret.secret.value
}*/