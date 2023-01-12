module "DB_ADMIN" {
 source = "./roles"
 name = "DB_ADMIN"
 comment = "a role for SYSADMIN inc"
 role_name = ["SYSADMIN"]
 users = [
  module.ALL_USERS_UAT.USERS.UAT_USER01.name,
  module.ALL_USERS_UAT.USERS.UAT_USER02.name, 
 ]
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


module "DATA_VIZ" {
 source = "./roles"
 name = "DATA_VIZ"
 comment = "a role for SYSADMIN inc"
 role_name = ["DATA_ANALYST"]
 users = [
  module.ALL_USERS_DEV_VIZ.USERS.DEV_USER04.name,
  module.ALL_USERS_DEV_VIZ.USERS.DEV_USER05.name,
  module.ALL_USERS_DEV_VIZ.USERS.VIZ_USER01.name,
  module.ALL_USERS_DEV_VIZ.USERS.VIZ_USER02.name, 
 
 ]
}

