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
# connect to your Snowflake account kk
provider "snowflake" {
  account = var.snowflake_account
  # region = "your-region-here" # fill-in only if required
  username = var.snowflake_username
  password = var.snowflake_password # do not use, we'll set an env var instead
  role     = var.snowflake_role
}


module "MARKETING_SMALL_WH_MOD_05" {
  source            = "./warehouse"
  warehouse_name    = "MARKETING_SMALL_WH_MOD_05"
  warehouse_size    = "SMALL"
  roles = {
    "OWNERSHIP" = ["MARKETING"],
    "USAGE" = ["MARKETING","SALES"]
  }
  with_grant_option = false
}

module "MARKETING_SMALL_WH_MOD_06" {
  source            = "./warehouse"
  warehouse_name    = "MARKETING_SMALL_WH_MOD_06"
  warehouse_size    = "SMALL"
  roles = {
    "OWNERSHIP" = ["MARKETING"],
    "USAGE" = ["MARKETING","SALES"]
  }
  with_grant_option = false
}


module "MARKETING_SMALL_WH_MOD_07" {
  source            = "./warehouse"
  warehouse_name    = "MARKETING_SMALL_WH_MOD_07"
  warehouse_size    = "SMALL"
  roles = {
    "OWNERSHIP" = ["MARKETING"],
    "USAGE" = ["MARKETING","SALES"]
  }
  with_grant_option = false
}

module "MARKETING_SMALL_WH_MOD_testrevert" {
  source            = "./warehouse"
  warehouse_name    = "MARKETING_SMALL_WH_MOD_testrevert"
  warehouse_size    = "SMALL"
  roles = {
    "OWNERSHIP" = ["MARKETING"],
    "USAGE" = ["MARKETING","SALES"]
  }
  with_grant_option = false
}


module "MARKETING_DB_9" {
  source = "./database01"
  db_name = "MARKETING_DB_9"
  db_comment = "a database for marketing"
  db_data_retention_time_in_days = 1
  db_role_grants = {
    "OWNERSHIP" = ["MARKETING"],
    "USAGE" = ["MARKETING","SALES"]
  }
  schemas = ["FACEBOOK","TWITTER"]
  schema_grants = {
   "FACEBOOK OWNERSHIP" = {"roles"= ["MARKETING"]},
   "FACEBOOK USAGE" = {"roles"= ["SALES"]},
   "TWITTER OWNERSHIP" = {"roles"= ["MARKETING"]},
   "TWITTER USAGE"= {"roles"= ["SALES"]},
   "TWITTER CREATE FUNCTION"= {"roles"= ["SALES"]},
   "TWITTER CREATE PIPE" = {"roles"= ["SALES"]}
  }
  
}

output "MARKETING_DB" {
  value = module.MARKETING_DB_9
}