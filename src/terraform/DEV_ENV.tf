# USERS FOR PROD ENV

module "ALL_USERS_DEV_VIZ" {
  source = "./users"

  user_maps = {

    "DEV_USER04" : {"first_name" = "DEV","last_name"="user1","email"="DEV_user1@snowflake.example","default_warehouse"="WAREHOUSE_DEV_WH05","default_role"="DATA_VIZ"},
    "DEV_USER05" : {"first_name" = "DEV","last_name"="user2","email"="DEV_user2@snowflake.example","default_warehouse"="WAREHOUSE_DEV_WH05","default_role"="DATA_VIZ"},
    "VIZ_USER01" : {"first_name" = "DEV","last_name"="user3","email"="DEV_user3@snowflake.example","default_warehouse"="WAREHOUSE_DEV_WH05","default_role"="DATA_VIZ"},
    "VIZ_USER02" : {"first_name" = "DEV","last_name"="user3","email"="DEV_user4@snowflake.example","default_warehouse"="WAREHOUSE_DEV_WH05","default_role"="DATA_VIZ"}

  }
}

output "ALL_USERS_DEV_VIZ" {
  value = module.ALL_USERS_DEV_VIZ
  sensitive = true
}

module "DATA_VIZ" {
 source = "./roles"
 name = "DATA_VIZ"
 comment = "a role for SYSADMIN inc"
 role_name = ["DATA_ANALYST"]
 users = [
  module.ALL_USERS_DEV_VIZ.USERS.DEV_USER04.name,
  module.ALL_USERS_DEV_VIZ.USERS.DEV_USER05.name,
  module.ALL_USERS_DEV_VIZ.USERS.VIZ_USER01.name  
 ]
}


module "WAREHOUSE_DEV_WH05" {
  source            = "./warehouse"
  warehouse_name    = "WAREHOUSE_DEV_WH05"
  warehouse_size    = "SMALL"
  roles = {
    "OWNERSHIP" = ["DATA_ANALYST"],
    "USAGE" = ["DATA_ANALYST","DATA_VIZ"]
  }
  with_grant_option = false
}


module "DATABASE_DEV_DB05" {
  source = "./database01"
  db_name = "DATABASE_DEV_DB05"
  db_comment = "DATABASE FOR DEV_ENV_DB04"
  db_data_retention_time_in_days = 1
  db_role_grants = {
    "OWNERSHIP" = ["DATA_ANALYST"],
    "USAGE" = ["DATA_ANALYST","DATA_VIZ"]
  }
  schemas = ["STAGE_SCHEMA","TARGET_SCHEMA",]
  schema_grants = {
   "STAGE_SCHEMA OWNERSHIP" = {"roles"= ["DATA_ANALYST"]},
   "STAGE_SCHEMA USAGE" = {"roles"= ["DATA_ANALYST","DATA_VIZ"]},
   "TARGET_SCHEMA OWNERSHIP" = {"roles"= ["DATA_ANALYST"]},
   "TARGET_SCHEMA USAGE"= {"roles"= ["DATA_ANALYST","DATA_VIZ"]}
  }
  
}

output "DATABASE_DEV_DB05" {
  value = module.DATABASE_DEV_DB05
}

