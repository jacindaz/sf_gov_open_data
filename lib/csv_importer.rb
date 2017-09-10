require 'csv'
require_relative '../app/models/police_incident'

class CsvImporter
  def initialize(file_path)
    @file_path = File.absolute_path(file_path)
  end

  def process
    PoliceIncident.transaction do
      puts "Processing csv...."

      CSV.foreach(@file_path, headers: :downcase, converters: :all, header_converters: :downcase) do |row|
        row = row.to_h

        new_pi = PoliceIncident.new(
          incident_number: row["incidntnum"].to_i,
          category: row["category"].downcase,
          description: row["descript"].capitalize,
          day_of_week: row["dayofweek"].capitalize,
          date: Date.strptime(row["date"], '%m/%d/%y'),
          time: row["time"].to_time,
          police_department_district_name: row["pddistrict"].capitalize,
          resolution: row["resolution"].downcase,
          address: row["address"].capitalize,
          x_coordinate: row["x"].to_i,
          y_coordinate: row["y"].to_i,
          police_department_district_id: row["pdid"].to_i
        )

        new_pi.save!
        print "." if $. % 500 == 0
      end

      puts "Completed uploading!"
    end
  end
end
