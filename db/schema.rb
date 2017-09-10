# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170904200124) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "original_sf_gov_data", id: :serial, force: :cascade do |t|
    t.string "computed_region_bh8s_q3mv", limit: 255
    t.string "computed_region_fyvs_ahh9", limit: 255
    t.string "computed_region_p5aj_wyqh", limit: 255
    t.string "computed_region_rxqg_mtj9", limit: 255
    t.string "computed_region_yftq_j783", limit: 255
    t.string "address", limit: 255
    t.string "category", limit: 255
    t.string "date", limit: 255
    t.string "dayofweek", limit: 255
    t.string "descript", limit: 255
    t.string "incidntnum", limit: 255
    t.string "location", limit: 255
    t.string "pddistrict", limit: 255
    t.string "pdid", limit: 255
    t.string "resolution", limit: 255
    t.string "time", limit: 255
    t.string "x", limit: 255
    t.string "y", limit: 255
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

end
