# == Schema Information
#
# Table name: reports
#
#  id                                           :bigint           not null, primary key
#  about_causes_of_infertility                  :text
#  about_work_and_working_style                 :text
#  adoption                                     :integer
#  age_of_partner_at_end_of_treatment           :integer
#  all_cost                                     :integer
#  all_grant_amount                             :integer
#  all_number_of_sairan                         :integer
#  all_number_of_transplants                    :integer
#  amh                                          :integer
#  annual_income                                :integer
#  annual_income_status                         :integer          default("show"), not null
#  average_waiting_time                         :integer
#  blastocyst_grade1                            :integer
#  blastocyst_grade1_supplementary_explanation  :text
#  blastocyst_grade2                            :integer
#  blastocyst_grade2_supplementary_explanation  :text
#  bmi                                          :integer
#  briefing_session                             :integer
#  capital_size                                 :integer
#  capital_size_status                          :integer
#  city_at_the_time_status                      :integer          default("show"), not null
#  clinic_review                                :text
#  clinic_selection_criteria                    :integer
#  comfort_of_space                             :integer
#  content                                      :text
#  cost                                         :integer
#  credit_card_validity                         :integer
#  creditcards_can_be_used_from_more_than       :integer
#  current_state                                :integer
#  department                                   :integer
#  department_status                            :integer
#  description_of_eggs_and_sperm_used           :text
#  details_of_icsi                              :integer
#  doctor_quality                               :integer
#  domestic_or_foreign_capital                  :integer
#  domestic_or_foreign_capital_status           :integer
#  early_embryo_grade                           :integer
#  early_embryo_grade_supplementary_explanation :text
#  egg_maturity                                 :integer
#  embryo_culture_days                          :integer
#  embryo_stage                                 :integer
#  explanation_and_impression_about_ishoku      :text
#  explanation_and_impression_about_sairan      :text
#  explanation_of_cost                          :text
#  explanation_of_frozen_embryo_storage_cost    :text
#  fertility_treatment_number                   :integer
#  first_age_to_start                           :integer
#  frozen_embryo_storage_cost                   :integer
#  fuiku                                        :integer
#  fuiku_supplementary_explanation              :text
#  household_net_income                         :integer
#  household_net_income_status                  :integer          default("show"), not null
#  impression_of_price                          :integer
#  impression_of_technology                     :integer
#  industry_type                                :integer
#  industry_type_status                         :integer
#  notes_on_type_of_sairan_cycle                :text
#  number_of_aih                                :integer
#  number_of_clinics                            :integer
#  number_of_eggs_collected                     :integer
#  number_of_eggs_stored                        :integer
#  number_of_employees                          :integer
#  number_of_employees_status                   :integer
#  number_of_fertilized_eggs                    :integer
#  number_of_frozen_eggs                        :integer
#  number_of_miscarriages                       :integer
#  number_of_stillbirths                        :integer
#  number_of_times_the_grant_was_received       :integer
#  number_of_transferable_embryos               :integer
#  online_consultation                          :integer
#  online_consultation_details                  :text
#  other_effort_cost                            :integer
#  other_effort_supplementary_explanation       :text
#  ova_with_ivm                                 :integer
#  period_of_time_spent_traveling               :integer
#  pgt1                                         :integer
#  pgt1_status                                  :integer
#  pgt2                                         :integer
#  pgt2_status                                  :integer
#  pgt_supplementary_explanation                :text
#  pgt_supplementary_explanation_status         :integer
#  position                                     :integer
#  position_status                              :integer
#  prefecture_at_the_time_status                :integer          default("show"), not null
#  private_or_listed_company                    :integer
#  private_or_listed_company_status             :integer
#  probability_of_normal_morphology_of_sperm    :integer
#  reasons_for_choosing_this_clinic             :text
#  reservation_method                           :integer
#  selection_of_anesthesia_type                 :integer
#  semen_concentration                          :integer
#  semen_volume                                 :integer
#  smoking                                      :integer
#  special_inspection_supplementary_explanation :text
#  sperm_advance_rate                           :integer
#  sperm_description                            :text
#  sperm_motility                               :integer
#  staff_quality                                :integer
#  status                                       :integer          default("released"), not null
#  supplement_cost                              :integer
#  supplement_supplementary_explanation         :text
#  supplementary_explanation_of_grant           :text
#  suspended_or_retirement_job                  :integer
#  title                                        :string
#  total_amount_of_sperm                        :integer
#  total_number_of_eggs_transplanted            :integer
#  total_number_of_sairan                       :integer
#  total_number_of_transplants                  :integer
#  transplant_method                            :integer
#  treatment_end_age                            :integer
#  treatment_period                             :integer
#  treatment_start_age                          :integer
#  treatment_support_system                     :integer
#  type_of_ovarian_stimulation                  :integer
#  type_of_sairan_cycle                         :integer
#  types_of_eggs_and_sperm                      :integer
#  types_of_fertilization_methods               :integer
#  use_of_anesthesia                            :integer
#  work_style                                   :integer
#  work_style_status                            :integer
#  year_of_treatment_end                        :date
#  created_at                                   :datetime         not null
#  updated_at                                   :datetime         not null
#  city_id                                      :bigint
#  clinic_id                                    :bigint           not null
#  prefecture_id                                :bigint
#  user_id                                      :bigint           not null
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
