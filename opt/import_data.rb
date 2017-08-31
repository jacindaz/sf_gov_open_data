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
    file = File.read("/Users/jzhong/Documents/jacinda/sf_police_data/opt/original_sf_gov_data.json")

    @results = JSON.parse(file)
  end

  def json_response
    response = Net::HTTP.get(URI(@url))
    @json_response ||= JSON.parse(response)

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

