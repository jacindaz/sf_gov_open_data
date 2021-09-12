require "csv_importer"
require_relative "../../opt/import_data"

desc "Import csv"
task :import_csv, [:file_path] => :environment do |_, args|
  # args.with_defaults(file_path: 'opt/police_data/sample_police_data.csv')
  args.with_defaults(file_path: "opt/police_data/Police_Department_Incidents.csv")
  CsvImporter.new(args[:file_path]).process
end

desc "Import JSON"
task import_json: :environment do

  db_name = Rails.configuration.database_configuration[Rails.env]["database"]
  ImportData.new(db_name).process
end
