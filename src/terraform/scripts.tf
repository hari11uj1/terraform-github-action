module "ALL_USERS_DEV_VIZ" {
  source = "./users"

  user_maps = {

    "DEV_USER04" : {"first_name" = "DEV","last_name"="user1","email"="DEV_user1@snowflake.example","default_warehouse"="WAREHOUSE_DEV_WH05","default_role"="DATA_VIZ"},
    "DEV_USER05" : {"first_name" = "DEV","last_name"="user2","email"="DEV_user2@snowflake.example","default_warehouse"="WAREHOUSE_DEV_WH05","default_role"="DATA_VIZ"},
    "VIZ_USER01" : {"first_name" = "DEV","last_name"="user3","email"="DEV_user3@snowflake.example","default_warehouse"="WAREHOUSE_DEV_WH05","default_role"="DATA_VIZ"},
    "VIZ_USER02" : {"first_name" = "DEV","last_name"="user4","email"="DEV_user4@snowflake.example","default_warehouse"="WAREHOUSE_DEV_WH05","default_role"="DATA_VIZ"}

  }
}

output "ALL_USERS_DEV_VIZ" {
  value = module.ALL_USERS_DEV_VIZ
  sensitive = true
}

module "ALL_USERS_PROD" {
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

module "ALL_USERS_UAT" {
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


module "ALL_USERS_TEST" {
  source = "./users"

  user_maps = {

    "TEST_USER001" : {"first_name" = "test","last_name"="user1","email"="user@snowflake.example","default_warehouse"="WAREHOUSE_DEV_WH04","default_role"="DATA_ANALYST"},
    "TEST_USER002" : {"first_name" = "test","last_name"="user2","email"="user2@snowflake.example","default_warehouse"="WAREHOUSE_DEV_WH04","default_role"="DATA_ANALYST"},
    "TEST_USER003" : {"first_name" = "test","last_name"="user3","email"="user3@snowflake.example","default_warehouse"="WAREHOUSE_DEV_WH04","default_role"="DATA_ANALYST"},
    "TEST_USER003" : {"first_name" = "test","last_name"="user3","email"="user3@snowflake.example","default_warehouse"="WAREHOUSE_DEV_WH04","default_role"="DATA_ANALYST"}
  }
}

output "ALL_USERS" {
  value = module.ALL_USERS_TEST
  sensitive = true
}


module "ALL_USERS_DEV" {
  source = "./users"

  user_maps = {

    "DEV_USER01" : {"first_name" = "DEV","last_name"="user01","email"="DEV_user1@snowflake.example","default_warehouse"="WAREHOUSE_UAT_WH03","default_role"="DATA_ENGG"},
    "DEV_USER02" : {"first_name" = "DEV","last_name"="user02","email"="DEV_user2@snowflake.example","default_warehouse"="WAREHOUSE_UAT_WH03","default_role"="DATA_ENGG"},
    "DEV_USER03" : {"first_name" = "DEV","last_name"="user03","email"="DEV_user3@snowflake.example","default_warehouse"="WAREHOUSE_UAT_WH03","default_role"="DATA_ENGG"},
    "UAT_USER004" : {"first_name" = "UAT","last_name"="user004","email"="UAT_user04@snowflake.example","default_warehouse"="WAREHOUSE_UAT_WH03","default_role"="DB_ADMIN1"}
  }

}
output "ALL_USERS_DEV" {
  value = module.ALL_USERS_DEV
  sensitive = true
}


resource "snowflake_user" "DEV_USER_MNUL" {
  name         = "Snowflake_User1"
  login_name   = "snowflake_user"
  comment      = "A user of snowflake."
  password     = "secret"
  disabled     = false
  display_name = "Snowflake User"
  email        = "user@snowflake.example"
  first_name   = "Snowflake"
  last_name    = "User"
  #default_warehouse       = "warehouse"
  #default_secondary_roles = ["ALL"]
  default_role            = "PUBLIC"
  must_change_password = true
}

module "DATA_ANALYST1" {
 source = "./roles"
 name = "DATA_ANALYST1"
 comment = "a role for SYSADMIN inc"
 role_name = ["DB_ADMIN1"]
 users = [snowflake_user.DEV_USER_MNUL.name]
}


module "DATA_ANALYST2" {
 source = "./roles"
 name = "DATA_ANALYST2"
 comment = "a role for SYSADMIN inc"
 role_name = ["DATA_ANALYST1"]
 users = [snowflake_user.DEV_USER_MNUL.name]
}



