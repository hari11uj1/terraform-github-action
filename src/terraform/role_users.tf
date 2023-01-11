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
  account = var.snowflake_account
  # region = "your-region-here" # fill-in only if required
  username = var.snowflake_username
  password = var.snowflake_password # do not use, we'll set an env var instead
  role     = var.snowflake_role
} 

  

# USERS FOR PROD ENV

module "ALL_USERS_UAT" {
  source = "./users"

  user_maps = {

    "UAT_USER1" : {"first_name" = "UAT","last_name"="user1","email"="UAT_user1@snowflake.example","default_warehouse"="WAREHOUSE_UAT_WH03","default_role"="UAT_ROLES"},
    "UAT_USER2" : {"first_name" = "UAT","last_name"="user2","email"="UAT_user2@snowflake.example","default_warehouse"="WAREHOUSE_UAT_WH03","default_role"="UAT_ROLES"},
    "UAT_USER3" : {"first_name" = "UAT","last_name"="user3","email"="UAT_user3@snowflake.example","default_warehouse"="WAREHOUSE_UAT_WH03","default_role"="UAT_ROLES"}
  }
}

output "ALL_USERS_UAT" {
  value = module.ALL_USERS_UAT
  sensitive = true
}

module "DB_ADMIN" {
 source = "./roles"
 name = "DB_ADMIN"
 comment = "a role for SYSADMIN inc"
 role_name = ["SYSADMIN"]
 users = [
  module.ALL_USERS_UAT.USERS.UAT_USER1.name,
  module.ALL_USERS_UAT.USERS.UAT_USER2.name,
  module.ALL_USERS_UAT.USERS.UAT_USER3.name  
 ]
}