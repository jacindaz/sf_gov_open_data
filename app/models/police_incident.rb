class PoliceIncident < ApplicationRecord
  validates :incident_number, numericality: true
  validates :category, presence: true
  validates :description, presence: true

  validates :day_of_week, inclusion: { in: %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday), message: "%{value} must be a day of the week" }
  validates :date, presence: true
  validates :time, presence: true
  validates :address, presence: true

  validates :police_department_district_id, numericality: true
  validates :police_department_district_name, presence: true
  validates :resolution, presence: true

  validates :x_coordinate, presence: true
  validates :y_coordinate, presence: true
  validates :location, presence: true
end
