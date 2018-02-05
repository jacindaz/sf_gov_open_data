require 'net/http'
require 'json'
require 'pg'
require 'pry'

class ImportData
  def initialize(database_name, drop_table=false)
    @connection = PG.connect(dbname: database_name)
    @drop_table = drop_table
  end

  def json_response
    response = Net::HTTP.get(URI(@url))
    puts "parsing json response..."
    @results ||= JSON.parse(response)
  end

  def process
    rollback if @drop_table
    json_response
    create_table

    puts "inserting values into table..."
    @connection.prepare('insert_statement', "insert into #{@table_name} (#{table_columns.join(', ')}) values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18)")
    @results.each do |row|
      next if row.values.length != 18
      @connection.exec_prepared('insert_statement', row.values)
    end
  end

  private

  def table_columns
    @table_columns ||= @results.first.keys.map!{ |c| c.sub(/:@/,'') }
  end

  def create_table
    puts "creating table...."

    create_table_sql = "create table if not exists #{@table_name} ("
    create_table_sql += "id serial primary key,"
    create_table_sql += (table_columns.join(" varchar(255), ") + " varchar(255)")
    create_table_sql += ");"

    @connection.exec(create_table_sql)
  end

  def rollback
    @connection.exec("drop table #{@table_name}") 
  end
end

i = ImportSFPoliceData.new
i.process
