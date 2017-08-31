require 'net/http'
require 'json'
require 'pg'
require 'pry'

class ImportSFPoliceData
  def initialize(url='https://data.sfgov.org/resource/cuks-n6tp.json')
    @url = url
    @connection = PG.connect( dbname: 'sf_police_data_development' )
    @table_name = 'original_sf_gov_data'
  end

  def json_response
    response = Net::HTTP.get(URI(@url))
    @json_response ||= JSON.parse(response)
  end

  def create_table
    columns = json_response.first.keys.map!{ |c| c.sub(/:@/,'') }

    create_table_sql = "create table #{@table_name} ("
    create_table_sql += "id integer PRIMARY KEY,"
    create_table_sql += (columns.join(" varchar(255), ") + " varchar(255)")
    create_table_sql += ");"

    @connection.exec(create_table_sql)
  end

  def rollback
    @connection.exec("drop table #{@table_name}")
  end
end

