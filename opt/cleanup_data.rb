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
    boolean_strings.any?{ |x| possible_boolean_strings.include?(x) }

    if boolean_strings
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
      puts "Added not null constraint to #{column_name}"
    else
      puts "Didn't update anything, #{column_name} is not a boolean column."
    end
  end
end

c = CleanupData.new('sf_police_data_development', 'eviction_notices')
c.alter_column_to_bool('breach')
