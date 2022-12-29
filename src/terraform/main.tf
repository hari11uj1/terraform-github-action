terraform {
    required_providers {
        snowflake = {
            source  = "Snowflake-Labs/snowflake"
            version = "0.39.0"
        }
    }
}# connect to your Snowflake account
provider "snowflake" {
    account = "og99478.central-india.azure"
    # region = "your-region-here" # fill-in only if required
    username = "HARISHKUMAR"
    password = "11Uj1a0318" # do not use, we'll set an env var instead
    role = "accountadmin"
}