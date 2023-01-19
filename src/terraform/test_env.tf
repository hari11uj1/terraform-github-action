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

  #account = "hy80966"
  #region  = "AZURE_CENTRALINDIA"
  #username = "HARISHKUMAR2"

  #features {}
  account = var.snowflake_account
  # region = "your-region-here" # fill-in only if required
  username = var.snowflake_username
  #password = var.snowflake_password # do not use, we'll set an env var instead
  role     = var.snowflake_role 
} 

  

# USERS FOR PROD ENV

/*module "ALL_USERS_UAT" {
  source = "./users"

  user_maps = {

    "UAT_USER01" : {"first_name" = "UAT","last_name"="user1","email"="UAT_user01@snowflake.example","default_warehouse"="WAREHOUSE_TEST_WH001","default_role"="DB_ADMIN"},
    "UAT_USER02" : {"first_name" = "UAT","last_name"="user2","email"="UAT_user02@snowflake.example","default_warehouse"="WAREHOUSE_TEST_WH001","default_role"="DB_ADMIN"},

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
  module.ALL_USERS_UAT.USERS.UAT_USER01.name,
  module.ALL_USERS_UAT.USERS.UAT_USER02.name, 
 ]
}*/

module "WAREHOUSE_TEST_WH001" {
  source            = "./warehouse"
  warehouse_name    = "WAREHOUSE_TEST_WH001"
  warehouse_size    = "SMALL"
  roles = {
    "OWNERSHIP" = ["SYSADMIN"],
    "USAGE" = ["SYSADMIN","DB_ADMIN"]
  }
  with_grant_option = false
}

module "DATABASE_TEST_DB01" {
  source = "./database01"
  db_name = "DATABASE_TEST_DB01"
  db_comment = "DATABASE FOR TEST_ENV_DB01"
  db_data_retention_time_in_days = 1
  db_role_grants = {
    "OWNERSHIP" = ["SYSADMIN"],
    "USAGE" = ["SYSADMIN","DB_ADMIN"]
  }
  schemas = ["STAGE_SCHEMA","TARGET_SCHEMA"]
  schema_grants = {
   "STAGE_SCHEMA OWNERSHIP" = {"roles"= ["SYSADMIN"]},
   "STAGE_SCHEMA USAGE" = {"roles"= ["SYSADMIN","DB_ADMIN"]},
   "TARGET_SCHEMA OWNERSHIP" = {"roles"= ["SYSADMIN"]},
   "TARGET_SCHEMA USAGE"= {"roles"= ["SYSADMIN","DB_ADMIN"]},
  }
  
}

output "DATABASE_TEST_DB01" {
  value = module.DATABASE_TEST_DB01
}