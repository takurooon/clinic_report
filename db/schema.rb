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

ActiveRecord::Schema.define(version: 2020_01_03_001505) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.integer "code"
    t.bigint "prefecture_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["prefecture_id"], name: "index_cities_on_prefecture_id"
  end

  create_table "clinic_reviews", force: :cascade do |t|
    t.bigint "clinic_id", null: false
    t.bigint "user_id", null: false
    t.integer "clinic_selection_criteria"
    t.integer "average_waiting_time"
    t.text "review"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["clinic_id"], name: "index_clinic_reviews_on_clinic_id"
    t.index ["user_id"], name: "index_clinic_reviews_on_user_id"
  end

  create_table "clinics", force: :cascade do |t|
    t.string "name"
    t.integer "jsog_code"
    t.string "post_code"
    t.string "address1"
    t.string "address2"
    t.string "tel"
    t.integer "senkoishido"
    t.integer "fujinkashuyo"
    t.integer "shusanki"
    t.integer "ivf"
    t.integer "hai_ranshi_toketsu"
    t.integer "kenbijusei"
    t.integer "social_ranshitoketsu"
    t.integer "teikyoseishi_aih"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "city_id", null: false
    t.index ["city_id"], name: "index_clinics_on_city_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "comment", null: false
    t.bigint "user_id", null: false
    t.bigint "report_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id"], name: "index_comments_on_report_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "f_diseases", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "f_infertility_factors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "f_surgeries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "inspections", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "report_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "m_diseases", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "m_infertility_factors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "m_surgeries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "other_efforts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "prefectures", force: :cascade do |t|
    t.string "name"
    t.bigint "region1_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["region1_id"], name: "index_prefectures_on_region1_id"
  end

  create_table "region1s", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "report_f_diseases", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "f_disease_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["f_disease_id"], name: "index_report_f_diseases_on_f_disease_id"
    t.index ["report_id"], name: "index_report_f_diseases_on_report_id"
  end

  create_table "report_f_infertility_factors", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "f_infertility_factor_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["f_infertility_factor_id"], name: "index_report_f_infertility_factors_on_f_infertility_factor_id"
    t.index ["report_id"], name: "index_report_f_infertility_factors_on_report_id"
  end

  create_table "report_f_surgeries", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "f_surgery_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["f_surgery_id"], name: "index_report_f_surgeries_on_f_surgery_id"
    t.index ["report_id"], name: "index_report_f_surgeries_on_report_id"
  end

  create_table "report_inspections", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "inspection_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["inspection_id"], name: "index_report_inspections_on_inspection_id"
    t.index ["report_id"], name: "index_report_inspections_on_report_id"
  end

  create_table "report_m_diseases", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "m_disease_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["m_disease_id"], name: "index_report_m_diseases_on_m_disease_id"
    t.index ["report_id"], name: "index_report_m_diseases_on_report_id"
  end

  create_table "report_m_infertility_factors", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "m_infertility_factor_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["m_infertility_factor_id"], name: "index_report_m_infertility_factors_on_m_infertility_factor_id"
    t.index ["report_id"], name: "index_report_m_infertility_factors_on_report_id"
  end

  create_table "report_m_surgeries", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "m_surgery_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["m_surgery_id"], name: "index_report_m_surgeries_on_m_surgery_id"
    t.index ["report_id"], name: "index_report_m_surgeries_on_report_id"
  end

  create_table "report_other_efforts", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "other_effort_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["other_effort_id"], name: "index_report_other_efforts_on_other_effort_id"
    t.index ["report_id"], name: "index_report_other_efforts_on_report_id"
  end

  create_table "report_sairan_medicines", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "sairan_medicine_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id"], name: "index_report_sairan_medicines_on_report_id"
    t.index ["sairan_medicine_id"], name: "index_report_sairan_medicines_on_sairan_medicine_id"
  end

  create_table "report_scope_of_disclosures", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "scope_of_disclosure_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id"], name: "index_report_scope_of_disclosures_on_report_id"
    t.index ["scope_of_disclosure_id"], name: "index_report_scope_of_disclosures_on_scope_of_disclosure_id"
  end

  create_table "report_supplements", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "supplement_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id"], name: "index_report_supplements_on_report_id"
    t.index ["supplement_id"], name: "index_report_supplements_on_supplement_id"
  end

  create_table "report_tags", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id"], name: "index_report_tags_on_report_id"
    t.index ["tag_id"], name: "index_report_tags_on_tag_id"
  end

  create_table "report_transfer_medicines", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "transfer_medicine_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id"], name: "index_report_transfer_medicines_on_report_id"
    t.index ["transfer_medicine_id"], name: "index_report_transfer_medicines_on_transfer_medicine_id"
  end

  create_table "report_transfer_options", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "transfer_option_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id"], name: "index_report_transfer_options_on_report_id"
    t.index ["transfer_option_id"], name: "index_report_transfer_options_on_transfer_option_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "title"
    t.integer "current_state"
    t.date "year_of_treatment_end"
    t.integer "fertility_treatment_number"
    t.integer "number_of_clinics"
    t.integer "clinic_selection_criteria"
    t.integer "treatment_type"
    t.integer "treatment_start_age"
    t.integer "first_age_to_start"
    t.integer "treatment_end_age"
    t.integer "treatment_period"
    t.integer "number_of_aih"
    t.integer "amh"
    t.integer "bmi"
    t.integer "smoking"
    t.integer "types_of_eggs_and_sperm"
    t.integer "type_of_sairan_cycle"
    t.integer "total_number_of_sairan"
    t.integer "all_number_of_sairan"
    t.integer "number_of_eggs_collected"
    t.integer "egg_maturity"
    t.integer "ova_with_ivm"
    t.integer "types_of_fertilization_methods"
    t.integer "number_of_fertilized_eggs"
    t.integer "number_of_frozen_eggs"
    t.integer "embryo_culture_days"
    t.integer "embryo_stage"
    t.integer "early_embryo_grade"
    t.integer "blastocyst_grade1"
    t.integer "blastocyst_grade2"
    t.integer "total_number_of_transplants"
    t.integer "all_number_of_transplants"
    t.integer "number_of_eggs_stored"
    t.integer "cost"
    t.integer "all_cost"
    t.integer "credit_card_validity"
    t.integer "average_waiting_time"
    t.integer "reservation_method"
    t.integer "period_of_time_spent_traveling"
    t.integer "work_style"
    t.integer "industry_type"
    t.integer "private_or_listed_company"
    t.integer "domestic_or_foreign_capital"
    t.integer "capital_size"
    t.integer "department"
    t.integer "position"
    t.integer "annual_income"
    t.integer "household_net_income"
    t.integer "number_of_employees"
    t.integer "treatment_support_system"
    t.integer "suspended_or_retirement_job"
    t.text "content"
    t.text "clinic_review"
    t.text "reasons_for_choosing_this_clinic"
    t.integer "status", default: 1, null: false
    t.integer "annual_income_status", default: 0, null: false
    t.integer "household_net_income_status", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "clinic_id", null: false
    t.bigint "user_id", null: false
    t.bigint "prefecture_id"
    t.bigint "city_id"
    t.index ["city_id"], name: "index_reports_on_city_id"
    t.index ["clinic_id"], name: "index_reports_on_clinic_id"
    t.index ["prefecture_id"], name: "index_reports_on_prefecture_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "sairan_medicines", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "scope_of_disclosures", force: :cascade do |t|
    t.string "scope"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "supplements", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "tag_name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "transfer_medicines", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "transfer_options", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.integer "gender"
    t.datetime "birthday"
    t.string "icon"
    t.string "link"
    t.text "self_introduction"
    t.string "provider"
    t.string "uid"
    t.string "username"
    t.string "image_url"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cities", "prefectures"
  add_foreign_key "clinic_reviews", "clinics"
  add_foreign_key "clinic_reviews", "users"
  add_foreign_key "clinics", "cities"
  add_foreign_key "comments", "reports"
  add_foreign_key "comments", "users"
  add_foreign_key "prefectures", "region1s"
  add_foreign_key "report_f_diseases", "f_diseases"
  add_foreign_key "report_f_diseases", "reports"
  add_foreign_key "report_f_infertility_factors", "f_infertility_factors"
  add_foreign_key "report_f_infertility_factors", "reports"
  add_foreign_key "report_f_surgeries", "f_surgeries"
  add_foreign_key "report_f_surgeries", "reports"
  add_foreign_key "report_inspections", "inspections"
  add_foreign_key "report_inspections", "reports"
  add_foreign_key "report_m_diseases", "m_diseases"
  add_foreign_key "report_m_diseases", "reports"
  add_foreign_key "report_m_infertility_factors", "m_infertility_factors"
  add_foreign_key "report_m_infertility_factors", "reports"
  add_foreign_key "report_m_surgeries", "m_surgeries"
  add_foreign_key "report_m_surgeries", "reports"
  add_foreign_key "report_other_efforts", "other_efforts"
  add_foreign_key "report_other_efforts", "reports"
  add_foreign_key "report_sairan_medicines", "reports"
  add_foreign_key "report_sairan_medicines", "sairan_medicines"
  add_foreign_key "report_scope_of_disclosures", "reports"
  add_foreign_key "report_scope_of_disclosures", "scope_of_disclosures"
  add_foreign_key "report_supplements", "reports"
  add_foreign_key "report_supplements", "supplements"
  add_foreign_key "report_tags", "reports"
  add_foreign_key "report_tags", "tags"
  add_foreign_key "report_transfer_medicines", "reports"
  add_foreign_key "report_transfer_medicines", "transfer_medicines"
  add_foreign_key "report_transfer_options", "reports"
  add_foreign_key "report_transfer_options", "transfer_options"
  add_foreign_key "reports", "cities"
  add_foreign_key "reports", "clinics"
  add_foreign_key "reports", "prefectures"
  add_foreign_key "reports", "users"
end
