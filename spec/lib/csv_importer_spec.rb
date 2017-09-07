require "rails_helper"
require_relative '../../lib/csv_importer'

RSpec.describe CsvImporter do
  describe 'the csv importer' do
    it 'successfully imports a csv with the right number of objects' do
      CsvImporter.new('spec/lib/sample_police_data.csv').process
      length_of_csv_minus_headers = CSV.read('spec/lib/sample_police_data.csv').length - 1

      expect(PoliceIncident.count).to eq(length_of_csv_minus_headers)
    end
  end
end
