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
} */
  

#users for test env

module "ALL_USERS_TEST" {
  source = "./users"

  user_maps = {

    "TEST_USER001" : {"first_name" = "test","last_name"="user1","email"="user@snowflake.example","default_warehouse"="WAREHOUSE_DEV_WH04","default_role"="DATA_ANALYST"},
    "TEST_USER002" : {"first_name" = "test","last_name"="user2","email"="user2@snowflake.example","default_warehouse"="WAREHOUSE_DEV_WH04","default_role"="DATA_ANALYST"},
    "TEST_USER003" : {"first_name" = "test","last_name"="user3","email"="user3@snowflake.example","default_warehouse"="WAREHOUSE_DEV_WH04","default_role"="DATA_ANALYST"}
  }
}

output "ALL_USERS" {
  value = module.ALL_USERS_TEST
  sensitive = true
}

module "TEST_ROLES" {
 source = "./roles"
 name = "DATA_ANALYST"
 comment = "a role for DATA LOADER "
 role_name = ["DB_ADMIN"]
 users = [
  module.ALL_USERS_TEST.USERS.TEST_USER001.name,
  module.ALL_USERS_TEST.USERS.TEST_USER002.name,
  module.ALL_USERS_TEST.USERS.TEST_USER003.name  
 ]
}

module "WAREHOUSE_DEV_WH04" {
  source            = "./warehouse"
  warehouse_name    = "WAREHOUSE_DEV_WH04"
  warehouse_size    = "SMALL"
  roles = {
    "OWNERSHIP" = ["DB_ADMIN"],
    "USAGE" = ["DB_ADMIN","DATA_ANALYST"]
  }
  with_grant_option = false
}




module "DATABASE_DEV_DB04" {
  source = "./database01"
  db_name = "DATABASE_DEV_DB04"
  db_comment = "DATABASE FOR TEST_ENV_DB04"
  db_data_retention_time_in_days = 1
  db_role_grants = {
    "OWNERSHIP" = ["DB_ADMIN"],
    "USAGE" = ["DB_ADMIN","DATA_ANALYST"]
  }
  schemas = ["STAGE_SCHEMA","TARGET_SCHEMA"]
  schema_grants = {
   "STAGE_SCHEMA OWNERSHIP" = {"roles"= ["DB_ADMIN"]},
   "STAGE_SCHEMA USAGE" = {"roles"= ["DB_ADMIN","DATA_ANALYST"]},
   "TARGET_SCHEMA OWNERSHIP" = {"roles"= ["DB_ADMIN"]},
   "TARGET_SCHEMA USAGE"= {"roles"= ["DB_ADMIN","DATA_ANALYST"]},
  }
  
}

output "DATABASE_DEV_DB04" {
  value = module.DATABASE_DEV_DB04
}

