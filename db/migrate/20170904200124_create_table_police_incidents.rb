class CreateTablePoliceIncidents < ActiveRecord::Migration[5.1]
  def change
    create_table :police_incidents do |t|
      t.integer :incident_number, null: false
      t.string :category, null: false
      t.text :description, null: false

      t.string :day_of_week, null: false
      t.date :date, null: false
      t.time :time, null: false
      t.string :address, null: false

      t.integer :police_department_district_id, limit: 8, null: false
      t.string :police_department_district_name, null: false
      t.string :resolution, null: false

      t.string :x_coordinate, presence: true
      t.string :y_coordinate, presence: true

      t.timestamps
    end
  end
end
