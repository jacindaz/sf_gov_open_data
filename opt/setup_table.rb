require 'pg'
require 'pry'

class SetupTable
  def initialize(database_name, new_table_name, copied_table_name)
    @connection = PG.connect(dbname: database_name)
    @new_table_name = new_table_name
    @copied_table_name = copied_table_name
  end

  def copy_table
    sql = "DROP TABLE IF EXISTS #{@new_table_name};"
    sql += "CREATE TABLE #{@new_table_name} AS SELECT * FROM #{@copied_table_name};"
    @connection.exec(sql)

    verify_table_exists = @connection.exec("select table_catalog, table_schema, table_name from information_schema.tables where table_name = '#{@new_table_name}';").first
  end

  def add_primary_key
    add_primary_key = "ALTER TABLE #{@new_table_name} ADD COLUMN id SERIAL PRIMARY KEY;"
    @connection.exec(add_primary_key)
  end
end
