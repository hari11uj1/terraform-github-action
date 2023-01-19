# creating users asper module or templet which exist users_module
module "ALL_USERS_DEV01" {
  source = "./users"

  depends_on = [module.snowflake_WAREHOUSE_WH001.WAREHOUSE]

  user_maps = {

    "snowflake_user1" : {"first_name" = "snowflake_DEV","last_name"="user1","email"="snowflake_DEV_user1@snowflake.example","default_warehouse"="snowflake_WAREHOUSE_WH001","default_role"="DB_ADMIN01"},
    "snowflake_user2" : {"first_name" = "snowflake_DEV","last_name"="user2","email"="snowflake_DEV_user2@snowflake.example","default_warehouse"="snowflake_WAREHOUSE_WH001","default_role"="DATA_ENGG01"},
    "snowflake_user3" : {"first_name" = "snowflake_DEV","last_name"="user3","email"="snowflake_DEV_user3@snowflake.example","default_warehouse"="snowflake_WAREHOUSE_WH001","default_role"="DATA_LOADER01"},
    "snowflake_user4" : {"first_name" = "snowflake_DEV","last_name"="user4","email"="snowflake_DEV_user4@snowflake.example","default_warehouse"="snowflake_WAREHOUSE_WH001","default_role"="DATA_ANALYST01"},
    "snowflake_user5" : {"first_name" = "snowflake_DEV","last_name"="user4","email"="snowflake_DEV_user5@snowflake.example","default_warehouse"="snowflake_WAREHOUSE_WH001","default_role"="DATA_VIZ01"}

  }
}

output "ALL_USERS_DEV01" {
  value = module.ALL_USERS_DEV01
  sensitive = true
}

# will create a role and asigins to users

module "DB_ADMIN01" {
 source = "./roles"
 name = "DB_ADMIN01"
 comment = "a role for SYSADMIN inc"
 role_name = ["SYSADMIN"]
 users = [
  module.ALL_USERS_DEV01.USERS.snowflake_user1.name, 
 ]
}

module "DATA_ENGG01" {
 source = "./roles"
 name = "DATA_ENGG01"
 comment = "a role for SYSADMIN inc"
 role_name = ["DB_ADMIN01"]
 users = [
  module.ALL_USERS_DEV01.USERS.snowflake_user2.name,
 ]
}

module "DATA_LOADER01" {
 source = "./roles"
 name = "DATA_LOADER01"
 comment = "a role for SYSADMIN inc"
 role_name = ["DATA_ENGG01"]
 users = [
  module.ALL_USERS_DEV01.USERS.snowflake_user3.name, 
 ]
}

module "DATA_ANALYST01" {
 source = "./roles"
 name = "DATA_ANALYST01"
 comment = "a role for SYSADMIN inc"
 role_name = ["DB_ADMIN01"]
 users = [
  module.ALL_USERS_DEV01.USERS.snowflake_user4.name, 
 ]
}

module "DATA_VIZ01" {
 source = "./roles"
 name = "DATA_VIZ01"
 comment = "a role for SYSADMIN inc"
 role_name = ["DATA_ANALYST01"]
 users = [
  module.ALL_USERS_DEV01.USERS.snowflake_user5.name,
 ]
}
  
# will create a warehouse and asign to users a
module "snowflake_WAREHOUSE_WH001" {
  source            = "./warehouse"
  warehouse_name    = "snowflake_WAREHOUSE_WH001"
  warehouse_size    = "SMALL"
  roles = {
    "OWNERSHIP" = ["SYSADMIN"],
    "USAGE" = ["SYSADMIN","DB_ADMIN1","DATA_ENGG1","DATA_ANALYST1","DATA_LOADER1","DATA_VIZ1"]
  }
  with_grant_option = false
  depends_on = [
    
  ]
}

# will create a database and asign db role grants and also asign schema role grants
module "DATABASE_DEV_DB001" {
  source = "./database01"
  db_name = "DATABASE_DEV_DB001"
  db_comment = "DATABASE FOR TEST_ENV_DB01"
  db_data_retention_time_in_days = 1
  db_role_grants = {
    "OWNERSHIP" = ["SYSADMIN"],
    "USAGE" = ["SYSADMIN","DB_ADMIN1","DATA_ENGG1","DATA_ANALYST1","DATA_LOADER1","DATA_VIZ1"]
  }
  schemas = ["STAGE_SCHEMA","TARGET_SCHEMA"]
  schema_grants = {
   "STAGE_SCHEMA OWNERSHIP" = {"roles"= ["SYSADMIN"]},
   "STAGE_SCHEMA USAGE" = {"roles"= ["SYSADMIN","DB_ADMIN"]},
   "TARGET_SCHEMA OWNERSHIP" = {"roles"= ["SYSADMIN"]},
   "TARGET_SCHEMA USAGE"= {"roles"= ["SYSADMIN","DB_ADMIN"]},
  }
  
}

output "DATABASE_DEV_DB001" {
  value = module.DATABASE_DEV_DB001
}


