require 'csv'

class CsvImporter
  def initialize(file_path)
    @file_path = File.absolute_path(file_path)
  end

  def process
    result = CSV.read(@file_path, headers: :downcase, converters: :all, header_converters: :downcase)
    result.map(&:to_h)
  end
end
