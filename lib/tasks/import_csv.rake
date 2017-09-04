require 'csv_importer'

desc "Import csv"
task :import_csv, [:file_path] do |t, args|
  args.with_defaults(file_path: 'opt/police_data/sample_police_data')
  CsvImporter.new(args[:file_path]).process
end
