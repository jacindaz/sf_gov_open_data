# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_02_05_230450) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_sources", force: :cascade do |t|
    t.string "title", null: false
    t.string "data_sf_uuid", null: false
    t.string "url", null: false
    t.string "table_name"
    t.date "date_downloaded", null: false
    t.date "data_freshness_date", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "json_endpoint"
    t.string "unique_identifier_column_name"
  end

  create_table "police_incidents", force: :cascade do |t|
    t.integer "incident_number", null: false
    t.string "category", null: false
    t.text "description", null: false
    t.string "day_of_week", null: false
    t.date "date", null: false
    t.time "time", null: false
    t.string "address", null: false
    t.bigint "police_department_district_id", null: false
    t.string "police_department_district_name", null: false
    t.string "resolution", null: false
    t.string "x_coordinate"
    t.string "y_coordinate"
    t.point "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "queries", force: :cascade do |t|
    t.string "query", null: false
    t.string "results", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
