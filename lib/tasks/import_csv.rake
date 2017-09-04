require 'csv_importer'

desc "Import csv"
task :import_csv, [:file_path] do |t, args|
  CsvImporter.new(args[:file_path]).process
end
