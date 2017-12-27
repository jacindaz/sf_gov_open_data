require 'pg'
require 'pry'

class CleanupData
  def initialize(database_name, table_name)
    @connection = PG.connect(dbname: database_name)
    @table_name = table_name
  end

  def alter_column_to_bool(column_name)
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
      puts "Added not null constraint to #{column_name}\n"
    else
      puts "Didn't update anything, #{column_name} is not a boolean column.\n"
    end
  end

  def alter_column_to_date(column_name)
    results = @connection.exec("select distinct #{column_name} from public.#{@table_name} where #{column_name} is not null and #{column_name} != '';")
    date_strings = results.map(&:values).flatten
    all_values_are_dates = date_strings.all?{ |string| string.scan(/\d+\/\d+\/\d+/).first == string }
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
end
