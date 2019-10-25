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

ActiveRecord::Schema.define(version: 2019_10_25_132804) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clinic_reviews", force: :cascade do |t|
    t.bigint "clinic_id", null: false
    t.bigint "report_id", null: false
    t.integer "cost"
    t.integer "credit_card_validity"
    t.integer "clinic_selection_criteria"
    t.integer "average_waiting_time"
    t.text "review"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["clinic_id"], name: "index_clinic_reviews_on_clinic_id"
    t.index ["report_id"], name: "index_clinic_reviews_on_report_id"
  end

  create_table "clinics", force: :cascade do |t|
    t.string "clinic_name"
    t.integer "jsog_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.integer "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "f_infertility_factors", force: :cascade do |t|
    t.integer "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "f_surgeries", force: :cascade do |t|
    t.integer "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "m_diseases", force: :cascade do |t|
    t.integer "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "m_infertility_factors", force: :cascade do |t|
    t.integer "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "m_surgeries", force: :cascade do |t|
    t.integer "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "ovarian_stimulations", force: :cascade do |t|
    t.integer "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "ovulation_inducers", force: :cascade do |t|
    t.integer "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "ovulation_inhibitors", force: :cascade do |t|
    t.integer "name"
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

  create_table "report_ovarian_stimulations", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "ovarian_stimulation_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ovarian_stimulation_id"], name: "index_report_ovarian_stimulations_on_ovarian_stimulation_id"
    t.index ["report_id"], name: "index_report_ovarian_stimulations_on_report_id"
  end

  create_table "report_ovulation_inducers", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "ovulation_inducer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ovulation_inducer_id"], name: "index_report_ovulation_inducers_on_ovulation_inducer_id"
    t.index ["report_id"], name: "index_report_ovulation_inducers_on_report_id"
  end

  create_table "report_ovulation_inhibitors", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "ovulation_inhibitor_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ovulation_inhibitor_id"], name: "index_report_ovulation_inhibitors_on_ovulation_inhibitor_id"
    t.index ["report_id"], name: "index_report_ovulation_inhibitors_on_report_id"
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

  create_table "report_transfer_options", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "transfer_option_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id"], name: "index_report_transfer_options_on_report_id"
    t.index ["transfer_option_id"], name: "index_report_transfer_options_on_transfer_option_id"
  end

  create_table "reports", force: :cascade do |t|
    t.integer "fertility_treatment_number"
    t.integer "treatment_type"
    t.integer "current_state"
    t.integer "work_style"
    t.integer "number_of_clinics"
    t.integer "address_at_that_time"
    t.integer "number_of_aih"
    t.integer "treatment_start_age"
    t.integer "treatment_end_age"
    t.integer "treatment_period"
    t.integer "amh"
    t.integer "bmi"
    t.integer "types_of_eggs_and_sperm"
    t.integer "total_number_of_sairan"
    t.integer "number_of_eggs_collected"
    t.integer "total_number_of_transplants"
    t.integer "number_of_eggs_stored"
    t.integer "type_of_sairan_cycle"
    t.integer "types_of_fertilization_methods"
    t.integer "number_of_fertilized_eggs"
    t.integer "number_of_frozen_eggs"
    t.text "content"
    t.integer "successful_egg_maturity"
    t.integer "successful_embryo_culture_days"
    t.integer "successful_embryo_grade"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.integer "latest_clinic_review_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "supplements", force: :cascade do |t|
    t.integer "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "transfer_options", force: :cascade do |t|
    t.integer "name"
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "clinic_reviews", "clinics"
  add_foreign_key "clinic_reviews", "reports"
  add_foreign_key "comments", "reports"
  add_foreign_key "comments", "users"
  add_foreign_key "report_f_diseases", "f_diseases"
  add_foreign_key "report_f_diseases", "reports"
  add_foreign_key "report_f_infertility_factors", "f_infertility_factors"
  add_foreign_key "report_f_infertility_factors", "reports"
  add_foreign_key "report_f_surgeries", "f_surgeries"
  add_foreign_key "report_f_surgeries", "reports"
  add_foreign_key "report_m_diseases", "m_diseases"
  add_foreign_key "report_m_diseases", "reports"
  add_foreign_key "report_m_infertility_factors", "m_infertility_factors"
  add_foreign_key "report_m_infertility_factors", "reports"
  add_foreign_key "report_m_surgeries", "m_surgeries"
  add_foreign_key "report_m_surgeries", "reports"
  add_foreign_key "report_ovarian_stimulations", "ovarian_stimulations"
  add_foreign_key "report_ovarian_stimulations", "reports"
  add_foreign_key "report_ovulation_inducers", "ovulation_inducers"
  add_foreign_key "report_ovulation_inducers", "reports"
  add_foreign_key "report_ovulation_inhibitors", "ovulation_inhibitors"
  add_foreign_key "report_ovulation_inhibitors", "reports"
  add_foreign_key "report_supplements", "reports"
  add_foreign_key "report_supplements", "supplements"
  add_foreign_key "report_tags", "reports"
  add_foreign_key "report_tags", "tags"
  add_foreign_key "report_transfer_options", "reports"
  add_foreign_key "report_transfer_options", "transfer_options"
  add_foreign_key "reports", "users"
end
