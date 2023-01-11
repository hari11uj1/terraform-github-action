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
      name = "SNOWFLAKE_ENV"
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

module "ALL_USERS_DEV" {
  source = "./users"

  user_maps = {

    "DEV_USER01" : {"first_name" = "DEV","last_name"="user1","email"="DEV_user1@snowflake.example","default_warehouse"="COMPUTE_WH","default_role"="PUBLIC"},
    "DEV_USER02" : {"first_name" = "DEV","last_name"="user2","email"="DEV_user2@snowflake.example","default_warehouse"="COMPUTE_WH","default_role"="PUBLIC"},
    "DEV_USER03" : {"first_name" = "DEV","last_name"="user3","email"="DEV_user3@snowflake.example"}
  }
}

output "ALL_USERS_DEV" {
  value = module.ALL_USERS_DEV
  sensitive = true
}

module "DEV_ROLES" {
 source = "./roles"
 name = "DEV_ROLES"
 comment = "a role for SYSADMIN inc"
 role_name = ["SYSADMIN"]
 users = [
  module.ALL_USERS_DEV.USERS.DEV_USER1.name,
  module.ALL_USERS_DEV.USERS.DEV_USER2.name,
  module.ALL_USERS_DEV.USERS.DEV_USER3.name  
 ]
}


module "WAREHOUSE_DEV_WH04" {
  source            = "./warehouse"
  warehouse_name    = "WAREHOUSE_DEV_WH04"
  warehouse_size    = "SMALL"
  roles = {
    "OWNERSHIP" = ["SYSADMIN"],
    "USAGE" = ["SYSADMIN","PUBLIC"]
  }
  with_grant_option = false
}


module "DATABASE_DEV_DB04" {
  source = "./database01"
  db_name = "DATABASE_DEV_DB04"
  db_comment = "DATABASE FOR DEV_ENV_DB04"
  db_data_retention_time_in_days = 1
  db_role_grants = {
    "OWNERSHIP" = ["SYSADMIN"],
    "USAGE" = ["SYSADMIN","PUBLIC"]
  }
  schemas = ["STAGE_SCHEMA","TARGET_SCHEMA",]
  schema_grants = {
   "STAGE_SCHEMA OWNERSHIP" = {"roles"= ["SYSADMIN"]},
   "STAGE_SCHEMA USAGE" = {"roles"= ["SYSADMIN","PUBLIC"]},
   "TARGET_SCHEMA OWNERSHIP" = {"roles"= ["SYSADMIN"]},
   "TARGET_SCHEMA USAGE"= {"roles"= ["SYSADMIN","PUBLIC"]}
  }
  
}

output "DATABASE_DEV_DB04" {
  value = module.DATABASE_DEV_DB04
}

