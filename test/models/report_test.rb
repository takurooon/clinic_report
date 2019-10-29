# == Schema Information
#
# Table name: reports
#
#  id                              :bigint           not null, primary key
#  address_at_that_time            :integer
#  amh                             :integer
#  bmi                             :integer
#  content                         :text
#  current_state                   :integer
#  fertility_treatment_number      :integer
#  number_of_aih                   :integer
#  number_of_clinics               :integer
#  number_of_eggs_collected        :integer
#  number_of_eggs_stored           :integer
#  number_of_fertilized_eggs       :integer
#  number_of_frozen_eggs           :integer
#  successful_egg_maturity         :integer
#  successful_embryo_culture_days  :integer
#  successful_embryo_grade_quality :integer
#  successful_embryo_grade_size    :integer
#  successful_ova_with_ivm         :integer
#  total_number_of_sairan          :integer
#  total_number_of_transplants     :integer
#  treatment_end_age               :integer
#  treatment_period                :integer
#  treatment_start_age             :integer
#  treatment_type                  :integer
#  type_of_sairan_cycle            :integer
#  types_of_eggs_and_sperm         :integer
#  types_of_fertilization_methods  :integer
#  work_style                      :integer
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  latest_clinic_review_id         :integer
#  user_id                         :bigint           not null
#
# Indexes
#
#  index_reports_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
