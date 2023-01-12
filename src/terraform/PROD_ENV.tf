/*module "ALL_USERS_PROD" {
  source = "./users"

  user_maps = {

    "PROD_USER01" : {"first_name" = "PROD","last_name"="user1","email"="PROD_user1@snowflake.example","default_warehouse"="WAREHOUSE_PROD_WH02","default_role"="DATA_LOADER"},
    "PROD_USER02" : {"first_name" = "PROD","last_name"="user2","email"="PROD_user2@snowflake.example","default_warehouse"="WAREHOUSE_PROD_WH02","default_role"="DATA_LOADER"},
    "PROD_USER03" : {"first_name" = "PROD","last_name"="user3","email"="PROD_user3@snowflake.example","default_warehouse"="WAREHOUSE_PROD_WH02","default_role"="DATA_LOADER"}
  }
}

output "ALL_USERS_PROD" {
  value = module.ALL_USERS_PROD
  sensitive = true
}

module "PROD_ROLES" {
 source = "./roles"
 name = "DATA_LOADER"
 comment = "a role for SYSADMIN inc"
 role_name = ["DATA_ENGG"]
 users = [
  module.ALL_USERS_PROD.USERS.PROD_USER01.name,
  module.ALL_USERS_PROD.USERS.PROD_USER02.name,
  module.ALL_USERS_PROD.USERS.PROD_USER03.name  
 ]
} */

module "WAREHOUSE_PROD_WH02" {
  source            = "./warehouse"
  warehouse_name    = "WAREHOUSE_PROD_WH02"
  warehouse_size    = "SMALL"
  roles = {
    "OWNERSHIP" = ["DB_ADMIN"],
    "USAGE" = ["DATA_ENGG","DATA_LOADER"]
  }
  with_grant_option = false
}


module "DATABASE_PROD_DB02" {
  source = "./database01"
  db_name = "DATABASE_PROD_DB02"
  db_comment = "DATABASE FOR PROD_ENV_DB02"
  db_data_retention_time_in_days = 1
  db_role_grants = {
    "OWNERSHIP" = ["DB_ADMIN"],
    "USAGE" = ["DATA_ENGG","DATA_LOADER"]
  }
  schemas = ["STAGE_SCHEMA","TARGET_SCHEMA"]
  schema_grants = {
   "STAGE_SCHEMA OWNERSHIP" = {"roles"= ["DB_ADMIN"]},
   "STAGE_SCHEMA USAGE" = {"roles"= ["DATA_ENGG","DATA_LOADER"]},
   "TARGET_SCHEMA OWNERSHIP" = {"roles"= ["DB_ADMIN"]},
   "TARGET_SCHEMA USAGE"= {"roles"= ["DATA_ENGG","DATA_LOADER"]},
  }
  
}

output "DATABASE_PROD_DB02" {
  value = module.DATABASE_PROD_DB02
}

