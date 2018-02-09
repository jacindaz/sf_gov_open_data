require 'net/http'
require 'json'
require 'pg'
require 'pry'

class ImportData
  def initialize(database_name, drop_tables = false)
    @connection = PG.connect(dbname: database_name)
    @drop_tables = drop_tables
  end

  def json_response(url)
    response = Net::HTTP.get(URI(url))
    puts "\nparsing json response..."
    JSON.parse(response)
  end

  def process
    DataSource.all.each do |data_source|
      rollback(data_source.table_name) if @drop_tables

      results = json_response(data_source.json_endpoint)
      json_columns = json_endpoint_columns(results)

      create_table(data_source.table_name, json_columns)
      insert_rows(data_source, results)
    end
  end

  def insert_rows(data_source, results)
    grouped_results_by_keys = results.group_by{ |row| row.keys.sort }

    grouped_results_by_keys.each do |array_of_keys, rows_with_same_keys|
      row_columns = array_of_keys.map!{ |c| c.sub(/:@/,"") }

      rows_with_same_keys.each_with_index do |row, index|
        prepared_insert = "insert into #{data_source.table_name} (#{row_columns.join(', ')}) values ("
        row_columns.each_with_index do |col, index|
          if index == (row_columns.length - 1)
            prepared_insert += "NULLIF($#{index + 1}, ''))"
          else
            prepared_insert += "NULLIF($#{index + 1}, ''), "
          end
        end

        unique_identifier_for_prepared_stmt = row["#{data_source.unique_identifier_column_name}"]
        prepared_insert_name = "insert_statement_#{data_source.table_name}_#{unique_identifier_for_prepared_stmt.delete('-')}"

        @connection.prepare(prepared_insert_name, prepared_insert)
        @connection.exec_prepared(prepared_insert_name, row.values)
        @connection.exec("deallocate all")
      end
    end

  end

  private

  def create_table(table_name, json_columns)
    puts "creating table...."

    create_table_sql = "create table if not exists #{table_name} ("
    create_table_sql += "id serial primary key,"
    create_table_sql += (json_columns.join(" text, ") + " text")
    create_table_sql += ");"
    @connection.exec(create_table_sql)

    existing_cols_sql = "select column_name from information_schema.columns where table_schema = 'public' and table_name = '#{table_name}'"
    columns_that_already_exist = @connection.exec(existing_cols_sql).values.flatten
    columns_that_need_to_be_created = json_columns - columns_that_already_exist

    puts "adding new columns to #{table_name}: #{columns_that_need_to_be_created.join(', ')}"
    columns_that_need_to_be_created.each do |column_name|
      @connection.exec("ALTER TABLE #{table_name} ADD COLUMN #{column_name} text;")
    end
  end

  def json_endpoint_columns(results)
    unique_columns = results.map(&:keys).flatten.uniq
    unique_columns.map!{ |c| c.sub(/:@/,"") }
  end

  def rollback(table_name)
    @connection.exec("drop table #{table_name}")
    puts "\ndropping table #{table_name}"
  end
end

