require 'net/http'
require 'json'
require 'pg'
require 'pry'

class ImportSFPoliceData
  def initialize(url='https://data.sfgov.org/resource/cuks-n6tp.json')
    @url = url
    @connection = PG.connect(dbname: 'sf_police_data_development')
    @table_name = 'original_sf_gov_data'
  end

  def json_from_file
    puts "reading the json file..."
    file = File.read("/Users/jzhong/Documents/jacinda/sf_police_data/opt/police_data/original_sf_gov_data.json")
    @results = JSON.parse(file)
  end

  def json_response
    response = Net::HTTP.get(URI(@url))
    puts "parsing json response..."
    @results ||= JSON.parse(response)
  end

  def process
    rollback
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
