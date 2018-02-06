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
  ImportData.new("sf_gov_open_data_dev").process
end
