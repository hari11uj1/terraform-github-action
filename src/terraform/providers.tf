terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.39.0"
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
 username = "HARISHKUMAR2"
 account  = "hy80966.central-india.azure"
} 

  