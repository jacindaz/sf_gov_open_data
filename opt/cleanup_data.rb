require 'pg'
require 'pry'

class CleanupData
  DATA_TYPES_TO_SKIP = ["boolean", "date"]

  def initialize(database_name, table_name)
    @connection = PG.connect(dbname: database_name)
    @table_name = table_name
  end

  def alter_column_to_bool(column_name)
    if column_data_type(column_name) != 'text'
      puts "Skipping, #{column_name} is already not a text column."
      return
    end

    possible_boolean_strings = ["FALSE", "false", "f", "TRUE", "true", "t"]

    results = @connection.exec("select distinct #{column_name} from public.#{@table_name};")
    boolean_strings = results.map(&:values).flatten
    is_bool_column = boolean_strings.any?{ |x| possible_boolean_strings.include?(x) }

    if is_bool_column
      alter_and_update = "
        ALTER TABLE #{@table_name}
        ALTER #{column_name} TYPE bool
        USING
        CASE WHEN #{column_name}='TRUE' THEN true
        WHEN #{column_name}='FALSE' then false
        ELSE null
        END
      "
      @connection.exec(alter_and_update)
      puts "Updated column #{column_name}"

      add_not_null_constraint = "ALTER TABLE #{@table_name} ALTER #{column_name} SET NOT NULL"
      @connection.exec(add_not_null_constraint)
      puts "Added not null constraint to #{column_name}\n\n"
    else
      puts "Didn't update anything, #{column_name} is not a boolean column.\n\n"
    end
  end

  def alter_column_to_date(column_name)
    if column_data_type(column_name) != 'text'
      puts "Skipping, #{column_name} is already not a text column."
      return
    end

    results = @connection.exec("select distinct #{column_name} from public.#{@table_name} where #{column_name} is not null and #{column_name} != '';")
    date_strings = results.map(&:values).flatten
    all_values_are_dates = date_strings.all?{ |string| string.scan(/\d+\/\d+\/\d+/).first == string }

    if all_values_are_dates
      alter_and_update = "
        ALTER TABLE #{@table_name}
        ALTER #{column_name} TYPE date
        USING
        CASE WHEN #{column_name} = '' THEN null
        ELSE #{column_name}::date
        END
      "
      @connection.exec(alter_and_update)
      puts "Updated column #{column_name} to a date, from a string.\n\n"
    else
      puts "Didn't update anything, not all values in #{column_name} are dates.\n\n"
    end
  end

  def get_table_column_names
    sql = "
      SELECT column_name
      FROM information_schema.columns
      WHERE table_schema = 'public'
      AND table_name='#{@table_name}'
    "
    results = @connection.exec(sql)
    results.map(&:values).flatten
  end

  private

  def column_data_type(column_name)
    @connection.exec("select data_type from information_schema.columns where column_name = '#{column_name}' and table_name = '#{@table_name}'").first["data_type"]
  end
end
