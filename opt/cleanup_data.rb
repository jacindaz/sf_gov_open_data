require "pg"
require "pry"

class CleanupData
  def initialize(database_name, table_name)
    @connection = PG.connect(dbname: database_name)
    @table_name = table_name
  end

  def perform
    get_text_columns.each { |column_name| alter_column_to_bool(column_name) }
    get_text_columns.each { |column_name| alter_column_to_int(column_name) }
    get_text_columns.each { |column_name| alter_column_to_date(column_name) }
  end

  def alter_column_to_bool(column_name)
    possible_boolean_strings = ["FALSE", "false", "f", "TRUE", "true", "t"]
    boolean_strings = column_values(column_name)

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
      puts "Updated column #{column_name} to boolean column."
    else
      puts "Didn't update anything, #{column_name} is not a boolean column.\n"
    end
  end

  def alter_column_to_int(column_name)
    strings_maybe_integers = column_values(column_name)
    column_type = calculate_integer_lengths(strings_maybe_integers)

    if integer_column?(strings_maybe_integers)
      alter_and_update = "ALTER TABLE #{@table_name}
                          ALTER #{column_name} TYPE #{column_type}
                          USING
                          CASE WHEN #{column_name} = '' THEN null
                          ELSE CAST(#{column_name} as #{column_type})
                          END"
      @connection.exec(alter_and_update)
      puts "Updated column #{column_name} to integer column."
    else
      puts "Didn't update anything, #{column_name} is not an integer column.\n"
    end
  end

  def alter_column_to_date(column_name)
    results = @connection.exec("select distinct #{column_name} from public.#{@table_name};")
    strings_maybe_dates = results.map(&:values).flatten

    if date_column?(strings_maybe_dates, column_name)
      alter_and_update = "ALTER TABLE #{@table_name}
                          ALTER #{column_name} TYPE date
                          USING CAST(#{column_name} as date) "
      @connection.exec(alter_and_update)
      puts "Updated column #{column_name} to date column."
    else
      puts "Didn't update anything, #{column_name} is not a date column.\n"
    end
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

  def date_column?(values, column_name)
    is_length10 = values.all?{ |string| true if string.length == 10 }

    if is_length10
      contains_delimiter = values.all? do |string|
        string.count("/") == 2 || string.count("-") == 2 || string.count(".") == 2
      end

      if contains_delimiter
        non_integers = []
        is_integer = values.all? do |string|
          if Integer(string.gsub("-", ""))
            true
          else
            non_integers << string
          end

          if non_integers.present?
            puts "Not a date column, these were not dates: #{non_integers.join(', ')}"
            false
          else
            true
          end
        end
      else
        return false
      end
    else
      return false
    end
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
