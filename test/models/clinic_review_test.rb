# == Schema Information
#
# Table name: clinic_reviews
#
#  id                        :bigint           not null, primary key
#  average_waiting_time      :integer
#  clinic_selection_criteria :integer
#  cost                      :integer
#  credit_card_validity      :integer
#  review                    :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  clinic_id                 :bigint           not null
#  report_id                 :bigint           not null
#
# Indexes
#
#  index_clinic_reviews_on_clinic_id  (clinic_id)
#  index_clinic_reviews_on_report_id  (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (clinic_id => clinics.id)
#  fk_rails_...  (report_id => reports.id)
#

require 'test_helper'

class ClinicReviewTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
