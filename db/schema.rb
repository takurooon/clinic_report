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

ActiveRecord::Schema.define(version: 2020_11_16_011633) do

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

  create_table "before_ishoku_hormones", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.integer "day", null: false
    t.float "e2"
    t.float "fsh"
    t.float "lh"
    t.float "p4"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id", "day"], name: "index_before_ishoku_hormones_on_report_id_and_day", unique: true
    t.index ["report_id"], name: "index_before_ishoku_hormones_on_report_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.integer "code"
    t.string "yomigana"
    t.bigint "prefecture_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["prefecture_id"], name: "index_cities_on_prefecture_id"
  end

  create_table "cl_selections", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.text "g_map"
    t.integer "senkoishido"
    t.integer "fujinkashuyo"
    t.integer "shusanki"
    t.integer "ivf"
    t.integer "hai_ranshi_toketsu"
    t.integer "kenbijusei"
    t.integer "social_ranshitoketsu"
    t.integer "teikyoseishi_aih"
    t.integer "pgt"
    t.integer "jis_art"
    t.integer "japco"
    t.integer "current_status"
    t.string "yomigana"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "city_id", null: false
    t.bigint "prefecture_id", null: false
    t.index ["city_id"], name: "index_clinics_on_city_id"
    t.index ["prefecture_id"], name: "index_clinics_on_prefecture_id"
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

  create_table "day_of_haibanhoishokus", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.integer "day", null: false
    t.float "e2"
    t.float "fsh"
    t.float "lh"
    t.float "p4"
    t.float "endometrial_thickness"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id", "day"], name: "index_day_of_haibanhoishokus_on_report_id_and_day", unique: true
    t.index ["report_id"], name: "index_day_of_haibanhoishokus_on_report_id"
  end

  create_table "day_of_sairans", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.integer "day", null: false
    t.float "e2"
    t.float "fsh"
    t.float "lh"
    t.float "p4"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id", "day"], name: "index_day_of_sairans_on_report_id_and_day", unique: true
    t.index ["report_id"], name: "index_day_of_sairans_on_report_id"
  end

  create_table "day_of_shokihaiishokus", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.integer "day", null: false
    t.float "e2"
    t.float "fsh"
    t.float "lh"
    t.float "p4"
    t.float "endometrial_thickness"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id", "day"], name: "index_day_of_shokihaiishokus_on_report_id_and_day", unique: true
    t.index ["report_id"], name: "index_day_of_shokihaiishokus_on_report_id"
  end

  create_table "f_funin_factors", force: :cascade do |t|
    t.string "name"
    t.string "yomigana"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "fuiku_inspections", force: :cascade do |t|
    t.string "name"
    t.string "yomigana"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "haibanhoishoku_hormones", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.integer "bt", null: false
    t.float "e2"
    t.float "fsh"
    t.float "lh"
    t.float "p4"
    t.float "hcg"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id", "bt"], name: "index_haibanhoishoku_hormones_on_report_id_and_bt", unique: true
    t.index ["report_id"], name: "index_haibanhoishoku_hormones_on_report_id"
  end

  create_table "itinerary_of_choosing_a_clinics", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "clinic_id", null: false
    t.integer "order_of_transfer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["clinic_id"], name: "index_itinerary_of_choosing_a_clinics_on_clinic_id"
    t.index ["report_id"], name: "index_itinerary_of_choosing_a_clinics_on_report_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "report_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "visitor_id", null: false
    t.integer "visited_id", null: false
    t.integer "report_id"
    t.integer "comment_id"
    t.string "action", default: "", null: false
    t.boolean "checked", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["comment_id"], name: "index_notifications_on_comment_id"
    t.index ["report_id"], name: "index_notifications_on_report_id"
    t.index ["visited_id"], name: "index_notifications_on_visited_id"
    t.index ["visitor_id"], name: "index_notifications_on_visitor_id"
  end

  create_table "pg_eplenishments", force: :cascade do |t|
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

  create_table "report_cl_selections", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "cl_selection_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cl_selection_id"], name: "index_report_cl_selections_on_cl_selection_id"
    t.index ["report_id"], name: "index_report_cl_selections_on_report_id"
  end

  create_table "report_f_funin_factors", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "f_funin_factor_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["f_funin_factor_id"], name: "index_report_f_funin_factors_on_f_funin_factor_id"
    t.index ["report_id"], name: "index_report_f_funin_factors_on_report_id"
  end

  create_table "report_fuiku_inspections", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "fuiku_inspection_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["fuiku_inspection_id"], name: "index_report_fuiku_inspections_on_fuiku_inspection_id"
    t.index ["report_id"], name: "index_report_fuiku_inspections_on_report_id"
  end

  create_table "report_pg_eplenishments", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "pg_eplenishment_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["pg_eplenishment_id"], name: "index_report_pg_eplenishments_on_pg_eplenishment_id"
    t.index ["report_id"], name: "index_report_pg_eplenishments_on_report_id"
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
    t.integer "transplant_method"
    t.integer "number_of_clinics"
    t.integer "treatment_end_age"
    t.integer "age_of_partner_at_end_of_treatment"
    t.integer "treatment_period"
    t.integer "amh"
    t.integer "sairan_age"
    t.integer "ishoku_age"
    t.integer "type_of_ovarian_stimulation"
    t.integer "use_of_anesthesia"
    t.integer "selection_of_anesthesia_type"
    t.integer "total_number_of_sairan"
    t.integer "number_of_eggs_collected"
    t.integer "ova_with_ivm"
    t.integer "types_of_fertilization_methods"
    t.integer "details_of_icsi"
    t.integer "number_of_fertilized_eggs"
    t.integer "number_of_transferable_embryos"
    t.integer "embryo_stage"
    t.integer "early_embryo_grade"
    t.integer "blastocyst_grade1"
    t.integer "blastocyst_grade2"
    t.integer "ishoku_type"
    t.integer "total_number_of_transplants"
    t.integer "total_number_of_eggs_transplanted"
    t.integer "fuiku"
    t.integer "sairan_cost"
    t.integer "ishoku_cost"
    t.integer "cost"
    t.integer "credit_card_validity"
    t.integer "creditcards_can_be_used_from_more_than"
    t.integer "staff_quality"
    t.integer "doctor_quality"
    t.integer "impression_of_price"
    t.integer "impression_of_technology"
    t.integer "comfort_of_space"
    t.integer "average_waiting_time"
    t.integer "average_waiting_time2"
    t.text "clinic_review"
    t.integer "period_of_time_spent_traveling"
    t.integer "work_style"
    t.integer "work_style_status", default: 0, null: false
    t.text "content"
    t.text "reasons_for_choosing_this_clinic"
    t.integer "status", default: 0, null: false
    t.integer "prefecture_at_the_time_status", default: 0, null: false
    t.integer "city_at_the_time_status", default: 0, null: false
    t.text "reason_for_transfer"
    t.text "treatment_policy"
    t.integer "number_of_visits_before_sairan"
    t.integer "number_of_visits_before_ishoku"
    t.integer "free_wifi"
    t.integer "possible_to_wait_outside_cl"
    t.integer "male_infertility"
    t.integer "level_of_male_infertility"
    t.integer "number_of_pronuclear_embryos", default: 0
    t.integer "number_of_early_embryos", default: 0
    t.integer "number_of_blastocysts", default: 0
    t.integer "number_of_unfrozen_embryos", default: 0
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

  create_table "sairan_hormones", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.integer "day", null: false
    t.float "e2"
    t.float "fsh"
    t.float "lh"
    t.float "p4"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id", "day"], name: "index_sairan_hormones_on_report_id_and_day", unique: true
    t.index ["report_id"], name: "index_sairan_hormones_on_report_id"
  end

  create_table "shokihaiishoku_hormones", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.integer "et", null: false
    t.float "e2"
    t.float "fsh"
    t.float "lh"
    t.float "p4"
    t.float "hcg"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id", "et"], name: "index_shokihaiishoku_hormones_on_report_id_and_et", unique: true
    t.index ["report_id"], name: "index_shokihaiishoku_hormones_on_report_id"
  end

  create_table "special_inspections", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.integer "name", null: false
    t.integer "place"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id"], name: "index_special_inspections_on_report_id"
  end

  create_table "transfer_options", force: :cascade do |t|
    t.string "name"
    t.string "yomigana"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "unsuccessful_ishoku_cycles", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.integer "number"
    t.integer "ishoku_age"
    t.integer "transplant_method"
    t.integer "ishoku_type"
    t.text "memo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id"], name: "index_unsuccessful_ishoku_cycles_on_report_id"
  end

  create_table "unsuccessful_sairan_cycles", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.integer "number"
    t.integer "sairan_age"
    t.integer "type_of_ovarian_stimulation"
    t.integer "number_of_eggs_collected"
    t.integer "number_of_fertilized_eggs"
    t.integer "number_of_transferable_embryos"
    t.integer "number_of_frozen_eggs"
    t.text "memo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id"], name: "index_unsuccessful_sairan_cycles_on_report_id"
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
    t.integer "gender", default: 0, null: false
    t.datetime "birthday"
    t.string "link"
    t.text "self_introduction"
    t.string "provider"
    t.string "uid"
    t.string "username"
    t.string "image_url"
    t.integer "all_number_of_sairan"
    t.integer "all_number_of_transplants"
    t.integer "all_cost"
    t.integer "first_age_to_start"
    t.integer "first_age_to_start_art"
    t.integer "number_of_aih"
    t.integer "number_of_chemical_abortions"
    t.integer "number_of_chemical_abortions_status", default: 0, null: false
    t.integer "number_of_early_miscarriages"
    t.integer "number_of_early_miscarriages_status", default: 0, null: false
    t.integer "number_of_late_miscarriages"
    t.integer "number_of_late_miscarriages_status", default: 0, null: false
    t.integer "number_of_times_the_grant_was_received"
    t.integer "all_grant_amount"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "before_ishoku_hormones", "reports"
  add_foreign_key "cities", "prefectures"
  add_foreign_key "clinic_reviews", "clinics"
  add_foreign_key "clinic_reviews", "users"
  add_foreign_key "clinics", "cities"
  add_foreign_key "clinics", "prefectures"
  add_foreign_key "comments", "reports"
  add_foreign_key "comments", "users"
  add_foreign_key "day_of_haibanhoishokus", "reports"
  add_foreign_key "day_of_sairans", "reports"
  add_foreign_key "day_of_shokihaiishokus", "reports"
  add_foreign_key "haibanhoishoku_hormones", "reports"
  add_foreign_key "itinerary_of_choosing_a_clinics", "clinics"
  add_foreign_key "itinerary_of_choosing_a_clinics", "reports"
  add_foreign_key "prefectures", "region1s"
  add_foreign_key "report_cl_selections", "cl_selections"
  add_foreign_key "report_cl_selections", "reports"
  add_foreign_key "report_f_funin_factors", "f_funin_factors"
  add_foreign_key "report_f_funin_factors", "reports"
  add_foreign_key "report_fuiku_inspections", "fuiku_inspections"
  add_foreign_key "report_fuiku_inspections", "reports"
  add_foreign_key "report_pg_eplenishments", "pg_eplenishments"
  add_foreign_key "report_pg_eplenishments", "reports"
  add_foreign_key "report_transfer_options", "reports"
  add_foreign_key "report_transfer_options", "transfer_options"
  add_foreign_key "reports", "cities"
  add_foreign_key "reports", "clinics"
  add_foreign_key "reports", "prefectures"
  add_foreign_key "reports", "users"
  add_foreign_key "sairan_hormones", "reports"
  add_foreign_key "shokihaiishoku_hormones", "reports"
  add_foreign_key "special_inspections", "reports"
  add_foreign_key "unsuccessful_ishoku_cycles", "reports"
  add_foreign_key "unsuccessful_sairan_cycles", "reports"
end
