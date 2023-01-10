terraform {
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

module "DB_ADMIN"{
  source = "./roles"
  name = "DB_ADMIN"
  comment = "a read only role for operations"
  role_name = ["SYSADMIN"]
  users = [
    module.ALL_USERS_DEV.USERS.DEV_USER1.name,
    module.ALL_USERS_DEV.USERS.DEV_USER2.name,
  ]
}

module "DATA_ENGG"{
  source = "./roles"
  name = "DATA_ENGG"
  comment = "a read only role for operations"
  role_name = [module.DB_ADMIN.name]
  users = [
    module.ALL_USERS_DEV.USERS.DEV_USER1.name,
    module.ALL_USERS_DEV.USERS.DEV_USER2.name,
  ]
}


module "DATA_ANALYST"{
  source = "./roles"
  name = "DATA_ANALYST"
  comment = "a read only role for operations"
  role_name = [module.DB_ADMIN.name]
  users = [
    module.ALL_USERS_DEV.USERS.DEV_USER1.name,
    module.ALL_USERS_DEV.USERS.DEV_USER2.name,
  ]
}

module "DATA_LOADER"{
  source = "./roles"
  name = "DATA_LOADER"
  comment = "a read only role for operations"
  role_name = [module.DATA_ANALYST.name]
  users = [
    module.ALL_USERS_DEV.USERS.DEV_USER1.name,
    module.ALL_USERS_DEV.USERS.DEV_USER2.name,
  ]
}

module "DATA_VIZ"{
  source = "./roles"
  name = "DATA_VIZ"
  comment = "a read only role for operations"
  role_name = [module.DATA_LOADER.name]
  users = [
    module.ALL_USERS_DEV.USERS.DEV_USER1.name,
    module.ALL_USERS_DEV.USERS.DEV_USER2.name,
  ]
}
