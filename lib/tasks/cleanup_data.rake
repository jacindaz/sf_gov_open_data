require_relative "../../opt/cleanup_data"
require_relative "../../opt/setup_table"

# Run it like this: rake set_up_table[sf_police_data_development,eviction_notices,original_eviction_notices]
desc "Set up eviction_notices table"
task :set_up_table, [:database_name, :new_table_name, :copied_table_name] => :environment do |_, args|
  setup = SetupTable.new(args[:database_name], args[:new_table_name], args[:copied_table_name])

  setup.copy_table
  setup.add_primary_key
end

# Run it like this: rake cleanup_data[sf_police_data_development,eviction_notices]
desc "Clean up data"
task :cleanup_data, [:database_name, :table_name] => :environment do |_, args|
  cleanup_data = CleanupData.new(args[:database_name], args[:table_name])

  table_columns = cleanup_data.get_table_column_names
  table_columns.each do |column_name|
    cleanup_data.alter_column_to_bool(column_name)
  end
end
