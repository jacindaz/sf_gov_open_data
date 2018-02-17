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

ActiveRecord::Schema.define(version: 20180205230450) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "affordable_housing_pipeline", id: :serial, limit: 2, force: :cascade do |t|
    t.text "project_id"
    t.text "project_status"
    t.text "project_name"
    t.text "street_number"
    t.text "street_name"
    t.text "street_type"
    t.bigint "zip_code"
    t.text "planning_address"
    t.text "apns"
    t.integer "supervisor_district", limit: 2
    t.text "planning_neighborhood"
    t.text "city_analysis_neighborhood"
    t.text "lead_agency"
    t.text "program_area"
    t.text "project_area"
    t.text "project_type"
    t.text "housing_tenure"
    t.date "issuance_of_notice_to_proceed"
    t.date "issuance_of_building_permit"
    t.date "issuance_of_first_construction_document"
    t.date "estimated_actual_construction_start_date"
    t.date "estimated_construction_completion"
    t.text "project_lead_sponsor"
    t.text "project_co_sponsor"
    t.text "project_owner"
    t.text "dbi_permit_number"
    t.text "planning__case_number"
    t.text "property_informaiton_map_link"
    t.text "planning_entitlements"
    t.date "entitlement_approval"
    t.text "section_415_declaration"
    t.text "recording_number"
    t.date "recording_date"
    t.integer "project_units"
    t.integer "affordable_units", limit: 2
    t.integer "market_rate_units", limit: 2
    t.text "_affordable"
    t.integer "sro_units", limit: 2
    t.integer "studio_units", limit: 2
    t.integer "_1bd_units", limit: 2
    t.integer "_2bd_units", limit: 2
    t.integer "_3bd_units", limit: 2
    t.integer "_4bd_units", limit: 2
    t.integer "_5_or_more_bd_units", limit: 2
    t.integer "mobility_units", limit: 2
    t.integer "manager_units", limit: 2
    t.text "manager_units_type"
    t.integer "family_units", limit: 2
    t.integer "senior_units"
    t.integer "tay_units", limit: 2
    t.integer "homeless_units", limit: 2
    t.integer "disabled_units", limit: 2
    t.integer "losp_units", limit: 2
    t.integer "public_housing_replacement_units", limit: 2
    t.integer "_20_ami", limit: 2
    t.integer "_30_ami", limit: 2
    t.integer "_50_ami"
    t.integer "_55_ami", limit: 2
    t.integer "_60_ami", limit: 2
    t.integer "_80_ami", limit: 2
    t.integer "_90_ami", limit: 2
    t.integer "_100_ami", limit: 2
    t.integer "_120_ami", limit: 2
    t.integer "_150_ami", limit: 2
    t.text "latitude"
    t.text "longitude"
    t.text "location"
  end

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

  create_table "eviction_notices", id: :serial, force: :cascade do |t|
    t.text "eviction_id"
    t.text "address"
    t.text "city"
    t.text "state"
    t.text "eviction_notice_source_zipcode"
    t.date "file_date"
    t.boolean "non_payment"
    t.boolean "breach"
    t.boolean "nuisance"
    t.boolean "illegal_use"
    t.boolean "failure_to_sign_renewal"
    t.boolean "access_denial"
    t.boolean "unapproved_subtenant"
    t.boolean "owner_move_in"
    t.boolean "demolition"
    t.boolean "capital_improvement"
    t.boolean "substantial_rehab"
    t.boolean "ellis_act_withdrawal"
    t.boolean "condo_conversion"
    t.boolean "roommate_same_unit"
    t.boolean "other_cause"
    t.boolean "late_payments"
    t.boolean "lead_remediation"
    t.boolean "development"
    t.boolean "good_samaritan_ends"
    t.text "constraints_date"
    t.text "supervisor_district"
    t.text "neighborhoods___analysis_boundaries"
    t.text "location"
  end

  create_table "original_affordable_housing_pipeline", id: false, force: :cascade do |t|
    t.text "project_id"
    t.text "project_status"
    t.text "project_name"
    t.text "street_number"
    t.text "street_name"
    t.text "street_type"
    t.text "zip_code"
    t.text "planning_address"
    t.text "apns"
    t.text "supervisor_district"
    t.text "planning_neighborhood"
    t.text "city_analysis_neighborhood"
    t.text "lead_agency"
    t.text "program_area"
    t.text "project_area"
    t.text "project_type"
    t.text "housing_tenure"
    t.text "issuance_of_notice_to_proceed"
    t.text "issuance_of_building_permit"
    t.text "issuance_of_first_construction_document"
    t.text "estimated_actual_construction_start_date"
    t.text "estimated_construction_completion"
    t.text "project_lead_sponsor"
    t.text "project_co_sponsor"
    t.text "project_owner"
    t.text "dbi_permit_number"
    t.text "planning__case_number"
    t.text "property_informaiton_map_link"
    t.text "planning_entitlements"
    t.text "entitlement_approval"
    t.text "section_415_declaration"
    t.text "recording_number"
    t.text "recording_date"
    t.text "project_units"
    t.text "affordable_units"
    t.text "market_rate_units"
    t.text "_affordable"
    t.text "sro_units"
    t.text "studio_units"
    t.text "_1bd_units"
    t.text "_2bd_units"
    t.text "_3bd_units"
    t.text "_4bd_units"
    t.text "_5_or_more_bd_units"
    t.text "mobility_units"
    t.text "manager_units"
    t.text "manager_units_type"
    t.text "family_units"
    t.text "senior_units"
    t.text "tay_units"
    t.text "homeless_units"
    t.text "disabled_units"
    t.text "losp_units"
    t.text "public_housing_replacement_units"
    t.text "_20_ami"
    t.text "_30_ami"
    t.text "_50_ami"
    t.text "_55_ami"
    t.text "_60_ami"
    t.text "_80_ami"
    t.text "_90_ami"
    t.text "_100_ami"
    t.text "_120_ami"
    t.text "_150_ami"
    t.text "latitude"
    t.text "longitude"
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
