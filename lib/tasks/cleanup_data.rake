require_relative '../../opt/cleanup_data'

# Run it like this: rake cleanup_data[sf_police_data_development,eviction_notices]
desc 'Clean up data'
task :cleanup_data, [:database_name, :table_name] => :environment do |_, args|
  cleanup_data = CleanupData.new(args[:database_name], args[:table_name])
  table_columns = cleanup_data.get_table_column_names

  table_columns.each do |column_name|
    cleanup_data.alter_column_to_bool(column_name)
  end
end
