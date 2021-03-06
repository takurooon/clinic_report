# == Schema Information
#
# Table name: reports
#
#  id                                     :bigint           not null, primary key
#  age_of_partner_at_end_of_treatment     :integer
#  amh                                    :integer
#  average_waiting_time                   :integer
#  average_waiting_time2                  :integer
#  blastocyst_grade1                      :integer
#  blastocyst_grade1_2                    :integer
#  blastocyst_grade2                      :integer
#  blastocyst_grade2_2                    :integer
#  choran                                 :integer
#  city_at_the_time_status                :integer          default("show"), not null
#  clinic_review                          :text
#  comfort_of_space                       :integer
#  content                                :text
#  cost                                   :integer
#  credit_card_validity                   :integer
#  creditcards_can_be_used_from_more_than :integer
#  culture_days                           :integer
#  culture_days_2                         :integer
#  current_state                          :integer
#  details_of_icsi                        :integer
#  doctor_quality                         :integer
#  early_embryo_grade                     :integer
#  early_embryo_grade_2                   :integer
#  egg_gv                                 :integer
#  egg_m1                                 :integer
#  egg_m2                                 :integer
#  egg_unknown                            :integer
#  embryo_stage                           :integer
#  embryo_stage_2                         :integer
#  explanation_of_costs                   :text
#  fertility_treatment_number             :integer
#  free_wifi                              :integer
#  fuiku                                  :integer
#  impression_of_price                    :integer
#  impression_of_technology               :integer
#  ishoku_age                             :integer
#  ishoku_cost                            :integer
#  ishoku_type                            :integer
#  level_of_male_infertility              :integer
#  male_infertility                       :integer
#  multiple_birth                         :integer
#  number_of_clinics                      :integer
#  number_of_eggs_collected               :integer
#  number_of_fertilized_eggs              :integer
#  number_of_frozen_blastocysts           :integer
#  number_of_frozen_early_embryos         :integer
#  number_of_frozen_pronuclear_embryos    :integer
#  number_of_transferable_embryos         :integer
#  number_of_unfrozen_embryos             :integer
#  number_of_visits_before_ishoku         :integer
#  number_of_visits_before_sairan         :integer
#  ova_with_ivm                           :integer
#  period_of_time_spent_traveling         :integer
#  possible_to_wait_outside_cl            :integer
#  prefecture_at_the_time_status          :integer          default("show"), not null
#  reason_for_transfer                    :text
#  reasons_for_choosing_this_clinic       :text
#  sairan_age                             :integer
#  sairan_cost                            :integer
#  selection_of_anesthesia_type           :integer
#  staff_quality                          :integer
#  status                                 :integer          default("released"), not null
#  switching_work_styles                  :integer
#  title                                  :string
#  total_number_of_eggs_transplanted      :integer
#  total_number_of_sairan                 :integer
#  total_number_of_transplants            :integer
#  transplant_method                      :integer
#  transplant_method_2                    :integer
#  treatment_end_age                      :integer
#  treatment_period                       :integer
#  treatment_policy                       :text
#  type_of_ovarian_stimulation            :integer
#  types_of_fertilization_methods         :integer
#  unknown_number_of_frozen_embryos       :integer
#  unknown_unfrozen_or_frozen_embryos     :integer
#  use_of_anesthesia                      :integer
#  work_style                             :integer
#  work_style_status                      :integer          default("show"), not null
#  year_of_treatment_end                  :date
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  city_id                                :bigint
#  clinic_id                              :bigint           not null
#  prefecture_id                          :bigint
#  user_id                                :bigint           not null
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
