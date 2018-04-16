require "pg"
require "pry"

class CleanupData
  def initialize(database_name, table_name)
    @connection = PG.connect(dbname: database_name)
    @table_name = table_name
    @columns = get_text_columns
  end

  def perform
    if @columns.any?
      @columns.each do |column_name|
        column_values_strings = column_values(column_name)

        if column_values_strings.any?
          if alter_column_to_bool(column_name, column_values_strings)
            next
          elsif alter_column_to_int(column_name, column_values_strings)
            next
          elsif alter_column_to_date(column_name, column_values_strings)
            next
          end
        else
          next
        end
      end
    end
  end

  def alter_column_to_bool(column_name, strings_maybe_bool)
    possible_boolean_strings = ["FALSE", "false", "f", "TRUE", "true", "t"]
    is_bool_column = strings_maybe_bool.any?{ |x| possible_boolean_strings.include?(x) }

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
      puts "Updated column #{column_name} to boolean column."
      @columns.delete(column_name)
      return true
    else
      puts "Didn't update anything, #{column_name} is not a boolean column.\n"
    end

    is_bool_column
  end

  def alter_column_to_int(column_name, strings_maybe_integers)
    column_type = calculate_integer_lengths(strings_maybe_integers)
    is_integer_column = integer_column?(strings_maybe_integers)

    if is_integer_column
      alter_and_update = "ALTER TABLE #{@table_name}
                          ALTER #{column_name} TYPE #{column_type}
                          USING
                          CASE WHEN #{column_name} = '' THEN null
                          ELSE CAST(#{column_name} as #{column_type})
                          END"
      @connection.exec(alter_and_update)
      puts "Updated column #{column_name} to integer column."
      @columns.delete(column_name)
    else
      puts "Didn't update anything, #{column_name} is not an integer column.\n"
    end

    is_integer_column
  end

  def alter_column_to_date(column_name, strings_maybe_dates)
    is_date_column = date_column?(strings_maybe_dates)
    if is_date_column
      alter_and_update = "ALTER TABLE #{@table_name}
                          ALTER #{column_name} TYPE date
                          USING
                          CASE WHEN #{column_name} = '' THEN null
                          ELSE CAST(#{column_name} as date)
                          END"
      @connection.exec(alter_and_update)
      puts "Updated column #{column_name} to date column."
      @columns.delete(column_name)
    else
      puts "Didn't update anything, #{column_name} is not a date column.\n"
    end

    is_date_column
  end

  private

  def get_text_columns
    sql = "
      SELECT column_name
      FROM information_schema.columns
      WHERE table_schema = 'public'
      AND table_name='#{@table_name}'
      AND data_type = 'text'
    "
    results = @connection.exec(sql)
    results.map(&:values).flatten
  end

  def column_values(column_name)
    results = @connection.exec("select distinct #{column_name} from public.#{@table_name} where #{column_name} != '' and #{column_name} is not null;")
    results.map(&:values).flatten
  end

  def integer_column?(values)
    values.all?{ |string| true if Integer(string) rescue false }
  end

  def date_column?(values)
    value_matches = []
    values.each do |value|
      ["-", ".", "/"].each do |delimiter|
        matched_string = /\d\d\d\d#{delimiter}\d\d#{delimiter}\d\d/.match(value).to_s

        if matched_string
          if matched_string.length == 10
            value_matches << true
            break
          end
        end

        value_matches << false
      end
    end

    value_matches.all?(true)
  end

  def calculate_integer_lengths(values)
    max_bits = values.max{ |string| string.to_i.to_s(2).length }.length

    if max_bits <= 2
      "smallint"
    elsif max_bits <= 4
      "integer"
    elsif max_bits <= 8
      "bigint"
    end
  end
end
