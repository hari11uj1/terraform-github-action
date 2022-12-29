resource "snowflake_database" "database" {
  name      = "my_tf_database"
}
resource "snowflake_schema" "schema" {
  database  = snowflake_database.database.name
  name      = "my_tf_schema"
}
resource "snowflake_table" "table" {
  database  = snowflake_database.database.name
  schema    = snowflake_schema.schema.name
  name      = "my_tf_table"
  column {
    name     = "id"
    type     = "int"
  }
  column {
    name     = "data"
    type     = "text"
  }
}