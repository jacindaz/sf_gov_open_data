require 'csv_importer'

desc "Import csv"
task :import_csv, [:file_path] => :environment do |t, args|
  args.with_defaults(file_path: 'opt/police_data/sample_police_data.csv')
  CsvImporter.new(args[:file_path]).process
end
