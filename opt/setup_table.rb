require "pg"
require "pry"
require "logger"

class SetupTable
  def initialize(database_name, new_table_name, copied_table_name)
    @connection = PG.connect(dbname: database_name)
    @new_table_name = new_table_name
    @copied_table_name = copied_table_name

    @logger = Logger.new(STDOUT)
  end

  def copy_table
    sql = "DROP TABLE IF EXISTS #{@new_table_name};"
    sql += "CREATE TABLE #{@new_table_name} AS SELECT * FROM #{@copied_table_name};"
    @connection.exec(sql)

    table_exists = @connection.exec("select table_catalog, table_schema, table_name from information_schema.tables where table_name = '#{@new_table_name}';").first

    if table_exists
      @logger.info("New table created!")
      @logger.info("Table: #{table_exists['table_name']}, Schema: #{table_exists['table_schema']}, Database: #{table_exists['table_catalog']}")
    else
      @logger.error("Table #{@new_table_name} was unable to be created. Boooo.")
    end
  end

  def add_primary_key
    add_primary_key = "ALTER TABLE #{@new_table_name} ADD COLUMN id SERIAL PRIMARY KEY;"
    @connection.exec(add_primary_key)

    @logger.info("Added a primary key to the #{@new_table_name} table!")
  end
end
