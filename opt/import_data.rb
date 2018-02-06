require 'net/http'
require 'json'
require 'pg'
require 'pry'

class ImportData
  def initialize(database_name, drop_tables=false)
    @connection = PG.connect(dbname: database_name)
    @drop_table = drop_tables
  end

  def json_response(url)
    response = Net::HTTP.get(URI(url))
    puts "parsing json response..."
    JSON.parse(response)
  end

  def process
  	DataSource.all.each do |data_source|
  	  rollback(data_source.table_name) if @drop_tables

  	  results = json_response(data_source.json_endpoint)
      table_columns = results.first.keys.map!{ |c| c.sub(/:@/,'') }

  	  create_table(data_source.table_name, table_columns)
  	  insert_rows(data_source, table_columns, results)
    end
  end

  def insert_rows(data_source, table_columns, results)
    puts "inserting values into table..."
    @connection.prepare('insert_statement', "insert into #{@table_name} (#{table_columns.join(', ')}) values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18)")
    @results.each do |row|
      next if row.values.length != 18
      @connection.exec_prepared('insert_statement', row.values)
    end
  end

  private

  def create_table(table_name, table_columns)
    puts "creating table...."

    create_table_sql = "create table if not exists #{table_name} ("
    create_table_sql += "id serial primary key,"
    create_table_sql += (table_columns.join(" varchar(255), ") + " varchar(255)")
    create_table_sql += ");"

    @connection.exec(create_table_sql)
  end

  def rollback(table_name)
    @connection.exec("drop table #{table_name}")
  end
end

