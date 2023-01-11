
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

module "ALL_USERS_UAT" {
  source = "./users"

  user_maps = {

    "UAT_USER1" : {"first_name" = "UAT","last_name"="user1","email"="UAT_user1@snowflake.example","default_warehouse"= module.WAREHOUSE_UAT_WH03.warehouse_name,"default_role"=module.UAT_ROLES.name},
    "UAT_USER2" : {"first_name" = "UAT","last_name"="user2","email"="UAT_user2@snowflake.example","default_warehouse"= module.WAREHOUSE_UAT_WH03.warehouse_name,"default_role"=module.UAT_ROLES.name},
    "UAT_USER3" : {"first_name" = "UAT","last_name"="user3","email"="UAT_user3@snowflake.example","default_warehouse"= module.WAREHOUSE_UAT_WH03.warehouse_name,"default_role"=module.UAT_ROLES.name}
  }
}

output "ALL_USERS_UAT" {
  value = module.ALL_USERS_UAT
  sensitive = true
}

module "UAT_ROLES" {
 source = "./roles"
 name = "UAT_ROLES"
 comment = "a role for SYSADMIN inc"
 role_name = ["SYSADMIN"]
 users = [
  module.ALL_USERS_UAT.USERS.UAT_USER1.name,
  module.ALL_USERS_UAT.USERS.UAT_USER2.name,  
 ]
}



module "WAREHOUSE_UAT_WH03" {
  source            = "./warehouse"
  warehouse_name    = "WAREHOUSE_UAT_WH03"
  warehouse_size    = "SMALL"
  roles = {
    "OWNERSHIP" = [module.UAT_ROLES.name],
    "USAGE" = [module.UAT_ROLES.name]
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
    "USAGE" = [module.UAT_ROLES.name]
  }
  schemas = ["STAGE_SCHEMA","TARGET_SCHEMA"]
  schema_grants = {
   "STAGE_SCHEMA OWNERSHIP" = {"roles"= ["SYSADMIN"]},
   "STAGE_SCHEMA USAGE" = {"roles"= [module.UAT_ROLES.name,"SYSADMIN"]},
   "TARGET_SCHEMA OWNERSHIP" = {"roles"= ["SYSADMIN"]},
   "TARGET_SCHEMA USAGE"= {"roles"= [module.UAT_ROLES.name,"SYSADMIN"]}
  }
  
}

output "DATABASE_UAT_DB03" {
  value = module.DATABASE_UAT_DB03
}

