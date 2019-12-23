# == Schema Information
#
# Table name: reports
#
#  id                               :bigint           not null, primary key
#  address_at_that_time             :integer
#  all_cost                         :integer
#  all_number_of_sairan             :integer
#  all_number_of_transplants        :integer
#  amh                              :integer
#  annual_income                    :integer
#  average_waiting_time             :integer
#  blastocyst_grade1                :integer
#  blastocyst_grade2                :integer
#  bmi                              :integer
#  capital_size                     :integer
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
#  private_or_listed_company        :integer
#  reasons_for_choosing_this_clinic :text
#  reservation_method               :integer
#  smoking                          :integer
#  status                           :integer          default("draft"), not null
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
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  clinic_id                        :bigint           not null
#  user_id                          :bigint           not null
#
# Indexes
#
#  index_reports_on_clinic_id  (clinic_id)
#  index_reports_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (clinic_id => clinics.id)
#  fk_rails_...  (user_id => users.id)
#

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
