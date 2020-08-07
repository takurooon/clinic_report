# == Schema Information
#
# Table name: reports
#
#  id                                           :bigint           not null, primary key
#  about_work_and_working_style                 :text
#  age_of_partner_at_end_of_treatment           :integer
#  amh                                          :integer
#  average_waiting_time                         :integer
#  average_waiting_time2                        :integer
#  blastocyst_grade1                            :integer
#  blastocyst_grade1_supplementary_explanation  :text
#  blastocyst_grade2                            :integer
#  blastocyst_grade2_supplementary_explanation  :text
#  briefing_session                             :integer
#  city_at_the_time_status                      :integer          default("show"), not null
#  cl_female_inspection_memo                    :text
#  cl_male_inspection_memo                      :text
#  clinic_review                                :text
#  comfort_of_space                             :integer
#  content                                      :text
#  cost                                         :integer
#  cost_burden_memo                             :text
#  credit_card_validity                         :integer
#  creditcards_can_be_used_from_more_than       :integer
#  current_state                                :integer
#  description_of_eggs_and_sperm_used           :text
#  description_of_eggs_and_sperm_used_status    :text
#  details_of_icsi                              :integer
#  doctor_quality                               :integer
#  early_embryo_grade                           :integer
#  early_embryo_grade_supplementary_explanation :text
#  egg_maturity                                 :integer
#  embryo_culture_days                          :integer
#  embryo_stage                                 :integer
#  explanation_and_impression_about_ishoku      :text
#  explanation_and_impression_about_sairan      :text
#  explanation_of_cost                          :text
#  f_disease_memo                               :text
#  f_other_effort_cost                          :integer
#  f_other_effort_memo                          :text
#  f_supplement_cost                            :integer
#  f_supplement_memo                            :text
#  f_surgery_memo                               :text
#  fertility_treatment_number                   :integer
#  followup_investigation                       :integer
#  followup_investigation_memo                  :text
#  fuiku                                        :integer
#  fuiku_supplementary_explanation              :text
#  household_net_income                         :integer
#  household_net_income_status                  :integer          default("show"), not null
#  how_long_to_continue_treatment               :integer
#  how_long_to_continue_treatment2              :integer
#  how_long_to_continue_treatment_memo          :text
#  impression_of_price                          :integer
#  impression_of_technology                     :integer
#  industry_type                                :integer
#  industry_type_status                         :integer          default("show"), not null
#  ishoku_age                                   :integer
#  ishoku_cost                                  :integer
#  ishoku_cost_explanation                      :text
#  ishoku_type                                  :integer
#  m_disease_memo                               :text
#  m_other_effort_cost                          :integer
#  m_other_effort_memo                          :text
#  m_supplement_cost                            :integer
#  m_supplement_memo                            :text
#  m_surgery_memo                               :text
#  notes_on_type_of_sairan_cycle                :text
#  number_of_clinics                            :integer
#  number_of_eggs_collected                     :integer
#  number_of_eggs_stored                        :integer
#  number_of_fertilized_eggs                    :integer
#  number_of_frozen_eggs                        :integer
#  number_of_injections                         :integer
#  number_of_transferable_embryos               :integer
#  number_of_visits_before_ishoku               :integer
#  number_of_visits_before_pregnancy_date       :integer
#  number_of_visits_before_sairan               :integer
#  online_consultation                          :integer
#  online_consultation_details                  :text
#  ova_with_ivm                                 :integer
#  period_of_time_spent_traveling               :integer
#  pgt1                                         :integer
#  pgt1_status                                  :integer          default("show"), not null
#  pgt2                                         :integer
#  pgt2_status                                  :integer          default("show"), not null
#  pgt_supplementary_explanation                :text
#  pgt_supplementary_explanation_status         :integer          default("show"), not null
#  prefecture_at_the_time_status                :integer          default("show"), not null
#  pregnancy_date                               :integer
#  pregnancy_date_memo                          :text
#  probability_of_normal_morphology_of_sperm    :float
#  reason_for_transfer                          :text
#  reasons_for_choosing_this_clinic             :text
#  reservation_method                           :integer
#  rest_period                                  :integer
#  rest_period_memo                             :text
#  sairan_age                                   :integer
#  sairan_cost                                  :integer
#  sairan_cost_explanation                      :text
#  selection_of_anesthesia_type                 :integer
#  self_injection                               :integer
#  semen_concentration                          :integer
#  semen_volume                                 :float
#  smoking_female                               :integer
#  smoking_male                                 :integer
#  special_inspection_memo                      :text
#  sperm_advance_rate                           :float
#  sperm_description                            :text
#  sperm_motility                               :float
#  staff_quality                                :integer
#  status                                       :integer          default("released"), not null
#  suspended_or_retirement_job                  :integer
#  title                                        :string
#  total_amount_of_sperm                        :integer
#  total_number_of_eggs_transplanted            :integer
#  total_number_of_sairan                       :integer
#  total_number_of_transplants                  :integer
#  transplant_method                            :integer
#  treatment_end_age                            :integer
#  treatment_period                             :integer
#  treatment_policy                             :text
#  treatment_schedule_memo                      :text
#  treatment_start_age                          :integer
#  treatment_support_system                     :integer
#  type_of_ovarian_stimulation                  :integer
#  type_of_sairan_cycle                         :integer
#  types_of_eggs_and_sperm                      :integer
#  types_of_eggs_and_sperm_status               :integer
#  types_of_fertilization_methods               :integer
#  use_of_anesthesia                            :integer
#  work_style                                   :integer
#  work_style_status                            :integer          default("show"), not null
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
