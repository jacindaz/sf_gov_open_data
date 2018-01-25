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

ActiveRecord::Schema.define(version: 20180125005809) do

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
  end

  create_table "eviction_notices", id: :serial, force: :cascade do |t|
    t.text "eviction_id"
    t.text "address"
    t.text "city"
    t.text "state"
    t.text "eviction_notice_source_zipcode"
    t.text "file_date"
    t.text "non_payment"
    t.text "breach"
    t.text "nuisance"
    t.text "illegal_use"
    t.text "failure_to_sign_renewal"
    t.text "access_denial"
    t.text "unapproved_subtenant"
    t.text "owner_move_in"
    t.text "demolition"
    t.text "capital_improvement"
    t.text "substantial_rehab"
    t.text "ellis_act_withdrawal"
    t.text "condo_conversion"
    t.text "roommate_same_unit"
    t.text "other_cause"
    t.text "late_payments"
    t.text "lead_remediation"
    t.text "development"
    t.text "good_samaritan_ends"
    t.text "constraints_date"
    t.text "supervisor_district"
    t.text "neighborhoods___analysis_boundaries"
    t.text "location"
  end

  create_table "original_eviction_notices", id: false, force: :cascade do |t|
    t.text "eviction_id"
    t.text "address"
    t.text "city"
    t.text "state"
    t.text "eviction_notice_source_zipcode"
    t.text "file_date"
    t.text "non_payment"
    t.text "breach"
    t.text "nuisance"
    t.text "illegal_use"
    t.text "failure_to_sign_renewal"
    t.text "access_denial"
    t.text "unapproved_subtenant"
    t.text "owner_move_in"
    t.text "demolition"
    t.text "capital_improvement"
    t.text "substantial_rehab"
    t.text "ellis_act_withdrawal"
    t.text "condo_conversion"
    t.text "roommate_same_unit"
    t.text "other_cause"
    t.text "late_payments"
    t.text "lead_remediation"
    t.text "development"
    t.text "good_samaritan_ends"
    t.text "constraints_date"
    t.text "supervisor_district"
    t.text "neighborhoods___analysis_boundaries"
    t.text "location"
  end

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
