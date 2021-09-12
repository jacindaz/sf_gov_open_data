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

      begin
        insert_or_update_rows(data_source, results)
      rescue => e
        puts "Oh no! We ran into an error:"
        puts e
      end
    end

    test_results
  end

  def insert_or_update_rows(data_source, results)
    json_unique_ids = results.map{ |result| result[data_source.unique_identifier_column_name] }.to_s.tr('\"', "'").tr("[", "(").tr("]", ")")
    existing_rows = @connection.exec("select #{data_source.unique_identifier_column_name} from #{data_source.table_name} where #{data_source.unique_identifier_column_name} in #{json_unique_ids}").values.flatten

    grouped_results_by_keys = results.group_by{ |row| row.keys.sort }
    num_rows_inserted = 0
    num_rows_updated = 0

    grouped_results_by_keys.each do |array_of_keys, rows_with_same_keys|
      row_columns = array_of_keys.map!{ |c| c.sub(/:@/,"") }

      rows_with_same_keys.each_with_index do |row, index|
        row = row_columns.zip(row.values).to_h
        row_identifier = row["#{data_source.unique_identifier_column_name}"]

        prepared_name = "insert_or_update_statement_#{data_source.table_name}_#{row_identifier.delete('-')}"

        if existing_rows.include?(row_identifier)
          prepared_update = update_prepared_statement(data_source, row, row_identifier)
          @connection.prepare(prepared_name, prepared_update)
          @connection.exec_prepared(prepared_name, row.values)

          num_rows_updated += 1
          print "." if num_rows_updated % 100
        else
          prepared_insert = insert_prepared_statement(data_source, row_columns)
          @connection.prepare(prepared_name, prepared_insert)
          @connection.exec_prepared(prepared_name, row.values)

          num_rows_inserted += 1
          print "." if num_rows_inserted % 100
        end

        @connection.exec("deallocate all")
      end
    end

    puts "\n# of rows inserted: #{num_rows_inserted}"
    puts "# of rows updated: #{num_rows_updated}"
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

  def insert_prepared_statement(data_source, row_columns)
    prepared_insert = "insert into #{data_source.table_name} (#{row_columns.join(', ')}) values ("

    row_columns.each_with_index do |col, index|
      if index == (row_columns.length - 1)
        prepared_insert += "NULLIF($#{index + 1}, ''))"
      else
        prepared_insert += "NULLIF($#{index + 1}, ''), "
      end
    end

    prepared_insert
  end

  def update_prepared_statement(data_source, row, row_identifier)
    row_mapping = ""
    row.keys.each_with_index{ |key, index| row_mapping += "#{key} = $#{index + 1}, " }
    row_mapping = row_mapping[0...-2]

    "UPDATE #{data_source.table_name}
     SET #{row_mapping}
     WHERE #{data_source.unique_identifier_column_name} = '#{row_identifier}'
     RETURNING id, #{data_source.unique_identifier_column_name}"
  end

  def rollback(table_name)
    @connection.exec("drop table #{table_name}")
    puts "\ndropping table #{table_name}"
  end

  def test_results
    expected_table_counts = {
      building_permits: 1000,
      eviction_notices: 1000,
      assessor_historical_secured_property_tax_roles: 1000,
      buyout_agreements: 857,
      affordable_housing_pipeline: 299
    }

    DataSource.all.each do |data_source|
      result = @connection.exec("select count(*) from #{data_source.table_name}").values[0][0].to_i

      if result != expected_table_counts[data_source.table_name.to_sym]
        puts "\n\e[1;31m=========="
        puts "Expected count for #{data_source.table_name} #{expected_table_counts[data_source.table_name.to_sym]}, actual count: #{result}"
        puts "==========\n"
      else
        puts "\n\e[1;32m=========="
        puts "Yay! Expected count #{expected_table_counts[data_source.table_name.to_sym]} (#{data_source.table_name}) matches actual count: #{result}"
        puts "==========\n"
      end
    end
  end
end

