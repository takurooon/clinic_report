# == Schema Information
#
# Table name: reports
#
#  id                               :bigint           not null, primary key
#  all_cost                         :integer
#  all_number_of_sairan             :integer
#  all_number_of_transplants        :integer
#  amh                              :integer
#  annual_income                    :integer
#  annual_income_status             :integer          default("show"), not null
#  average_waiting_time             :integer
#  blastocyst_grade1                :integer
#  blastocyst_grade2                :integer
#  bmi                              :integer
#  capital_size                     :integer
#  city_at_the_time_status          :integer          default("show"), not null
#  clinic_review                    :text
#  clinic_selection_criteria        :integer
#  content                          :text
#  cost                             :integer
#  credit_card_validity             :integer
#  current_state                    :integer
#  department                       :integer
#  domestic_or_foreign_capital      :integer
#  early_embryo_grade               :integer
#  egg_maturity                     :integer
#  embryo_culture_days              :integer
#  embryo_stage                     :integer
#  fertility_treatment_number       :integer
#  first_age_to_start               :integer
#  household_net_income             :integer
#  household_net_income_status      :integer          default("show"), not null
#  industry_type                    :integer
#  number_of_aih                    :integer
#  number_of_clinics                :integer
#  number_of_eggs_collected         :integer
#  number_of_eggs_stored            :integer
#  number_of_employees              :integer
#  number_of_fertilized_eggs        :integer
#  number_of_frozen_eggs            :integer
#  ova_with_ivm                     :integer
#  period_of_time_spent_traveling   :integer
#  position                         :integer
#  prefecture_at_the_time_status    :integer          default("show"), not null
#  private_or_listed_company        :integer
#  reasons_for_choosing_this_clinic :text
#  reservation_method               :integer
#  smoking                          :integer
#  status                           :integer          default("released"), not null
#  suspended_or_retirement_job      :integer
#  title                            :string
#  total_number_of_sairan           :integer
#  total_number_of_transplants      :integer
#  treatment_end_age                :integer
#  treatment_period                 :integer
#  treatment_start_age              :integer
#  treatment_support_system         :integer
#  treatment_type                   :integer
#  type_of_sairan_cycle             :integer
#  types_of_eggs_and_sperm          :integer
#  types_of_fertilization_methods   :integer
#  work_style                       :integer
#  year_of_treatment_end            :date
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  city_id                          :bigint
#  clinic_id                        :bigint           not null
#  prefecture_id                    :bigint
#  user_id                          :bigint           not null
#
# Indexes
#
#  index_reports_on_city_id        (city_id)
#  index_reports_on_clinic_id      (clinic_id)
#  index_reports_on_prefecture_id  (prefecture_id)
#  index_reports_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (clinic_id => clinics.id)
#  fk_rails_...  (prefecture_id => prefectures.id)
#  fk_rails_...  (user_id => users.id)
#

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
