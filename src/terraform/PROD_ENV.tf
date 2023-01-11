/*terraform {
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

module "ALL_USERS_PROD" {
  source = "./users"

  user_maps = {

    "PROD_USER01" : {"first_name" = "PROD","last_name"="user1","email"="PROD_user1@snowflake.example","default_warehouse"="WAREHOUSE_PROD_WH02","default_role"="PUBLIC"},
    "PROD_USER02" : {"first_name" = "PROD","last_name"="user2","email"="PROD_user2@snowflake.example","default_warehouse"="WAREHOUSE_PROD_WH02","default_role"="PUBLIC"},
    "PROD_USER03" : {"first_name" = "PROD","last_name"="user3","email"="PROD_user3@snowflake.example"}
  }
}

output "ALL_USERS_PROD" {
  value = module.ALL_USERS_PROD
  sensitive = true
}

module "PROD_ROLES" {
 source = "./roles"
 name = "DATA_ANALYST"
 comment = "a role for SYSADMIN inc"
 role_name = ["SYSADMIN"]
 users = [
  module.ALL_USERS_PROD.USERS.PROD_USER01.name,
  module.ALL_USERS_PROD.USERS.PROD_USER02.name,
  #module.ALL_USERS_PROD.USERS.PROD_USER03.name  
 ]
} */

module "WAREHOUSE_PROD_WH02" {
  source            = "./warehouse"
  warehouse_name    = "WAREHOUSE_PROD_WH02"
  warehouse_size    = "SMALL"
  roles = {
    "OWNERSHIP" = ["SYSADMIN"],
    "USAGE" = ["DB_ADMIN","DATA_ENGG"]
  }
  with_grant_option = false
}


module "DATABASE_PROD_DB02" {
  source = "./database01"
  db_name = "DATABASE_PROD_DB02"
  db_comment = "DATABASE FOR PROD_ENV_DB02"
  db_data_retention_time_in_days = 1
  db_role_grants = {
    "OWNERSHIP" = ["SYSADMIN"],
    "USAGE" = ["DATA_ENGG","DB_ADMIN"]
  }
  schemas = ["STAGE_SCHEMA","TARGET_SCHEMA"]
  schema_grants = {
   "STAGE_SCHEMA OWNERSHIP" = {"roles"= ["SYSADMIN"]},
   "STAGE_SCHEMA USAGE" = {"roles"= ["DATA_ENGG","DB_ADMIN"]},
   "TARGET_SCHEMA OWNERSHIP" = {"roles"= ["SYSADMIN"]},
   "TARGET_SCHEMA USAGE"= {"roles"= ["DATA_ENGG","DB_ADMIN"]},
  }
  
}

output "DATABASE_PROD_DB02" {
  value = module.DATABASE_PROD_DB02
}

