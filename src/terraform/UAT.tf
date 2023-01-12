# USERS FOR PROD ENV

/*module "ALL_USERS_DEV" {
  source = "./users"

  user_maps = {

    "DEV_USER01" : {"first_name" = "DEV","last_name"="user01","email"="DEV_user1@snowflake.example","default_warehouse"="WAREHOUSE_UAT_WH03","default_role"="DATA_ENGG"},
    "DEV_USER02" : {"first_name" = "DEV","last_name"="user02","email"="DEV_user2@snowflake.example","default_warehouse"="WAREHOUSE_UAT_WH03","default_role"="DATA_ENGG"},
    "DEV_USER03" : {"first_name" = "DEV","last_name"="user03","email"="DEV_user3@snowflake.example","default_warehouse"="WAREHOUSE_UAT_WH03","default_role"="DATA_ENGG"}
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
 role_name = ["DB_ADMIN"]
 users = [
  module.ALL_USERS_DEV.USERS.DEV_USER01.name,
  module.ALL_USERS_DEV.USERS.DEV_USER02.name,
  module.ALL_USERS_DEV.USERS.DEV_USER03.name  
 ]
}*/



module "WAREHOUSE_UAT_WH03" {
  source            = "./warehouse"
  warehouse_name    = "WAREHOUSE_UAT_WH03"
  warehouse_size    = "SMALL"
  roles = {
    "OWNERSHIP" = ["DB_ADMIN"],
    "USAGE" = ["DB_ADMIN","DATA_ENGG","DB_ADMIN1"]
  }
  with_grant_option = false
}


module "DATABASE_UAT_DB03" {
  source = "./database01"
  db_name = "DATABASE_UAT_DB03"
  db_comment = "DATABASE FOR UAT_ENV_DB03"
  db_data_retention_time_in_days = 1
  db_role_grants = {
    "OWNERSHIP" = ["DB_ADMIN"],
    "USAGE" = ["DB_ADMIN","DATA_ENGG","DB_ADMIN1"]
  }
  schemas = ["STAGE_SCHEMA","TARGET_SCHEMA"]
  schema_grants = {
   "STAGE_SCHEMA OWNERSHIP" = {"roles"= ["DB_ADMIN"]},
   "STAGE_SCHEMA USAGE" = {"roles"= ["DB_ADMIN","DATA_ENGG","DB_ADMIN1"]},
   "TARGET_SCHEMA OWNERSHIP" = {"roles"= ["DB_ADMIN"]},
   "TARGET_SCHEMA USAGE"= {"roles"= ["DB_ADMIN","DATA_ENGG","DB_ADMIN1"]}
  }
  
}

output "DATABASE_UAT_DB03" {
  value = module.DATABASE_UAT_DB03
}

