
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
  

# USERS FOR PROD ENV

module "ALL_USERS_DEV" {
  source = "./users"

  user_maps = {

    "DEV_USER01" : {"first_name" = "DEV","last_name"="user01","email"="DEV_user1@snowflake.example","default_warehouse"="WAREHOUSE_UAT_WH03","default_role"="PUBLIC"},
    "DEV_USER02" : {"first_name" = "DEV","last_name"="user02","email"="DEV_user2@snowflake.example","default_warehouse"="WAREHOUSE_UAT_WH03","default_role"="PUBLIC"},
    "DEV_USER03" : {"first_name" = "DEV","last_name"="user03","email"="DEV_user3@snowflake.example","default_warehouse"="WAREHOUSE_UAT_WH03","default_role"="PUBLIC"}
  }

}


output "ALL_USERS_DEV" {
  value = module.ALL_USERS_DEV
  sensitive = true
}

module "UAT_ROLES" {
 source = "./roles"
 name = "DATA_ENGG"
 comment = "a role for SYSADMIN inc"
 role_name = ["SYSADMIN"]
 users = [
  module.ALL_USERS_DEV.USERS.DEV_USER01.name,
  module.ALL_USERS_DEV.USERS.DEV_USER02.name,
  module.ALL_USERS_DEV.USERS.DEV_USER03.name  
 ]
}



module "WAREHOUSE_UAT_WH03" {
  source            = "./warehouse"
  warehouse_name    = "WAREHOUSE_UAT_WH03"
  warehouse_size    = "SMALL"
  roles = {
    "OWNERSHIP" = ["SYSADMIN"],
    "USAGE" = ["SYSADMIN","DB_ADMIN"]
  }
  with_grant_option = false
}


module "DATABASE_UAT_DB03" {
  source = "./database01"
  db_name = "DATABASE_UAT_DB03"
  db_comment = "DATABASE FOR UAT_ENV_DB03"
  db_data_retention_time_in_days = 1
  db_role_grants = {
    "OWNERSHIP" = ["SYSADMIN"],
    "USAGE" = ["DB_ADMIN","SYSADMIN"]
  }
  schemas = ["STAGE_SCHEMA","TARGET_SCHEMA"]
  schema_grants = {
   "STAGE_SCHEMA OWNERSHIP" = {"roles"= ["SYSADMIN"]},
   "STAGE_SCHEMA USAGE" = {"roles"= ["DB_ADMIN","SYSADMIN"]},
   "TARGET_SCHEMA OWNERSHIP" = {"roles"= ["SYSADMIN"]},
   "TARGET_SCHEMA USAGE"= {"roles"= ["DB_ADMIN","SYSADMIN"]}
  }
  
}

output "DATABASE_UAT_DB03" {
  value = module.DATABASE_UAT_DB03
}

