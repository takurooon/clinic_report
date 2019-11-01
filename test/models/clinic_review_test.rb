# == Schema Information
#
# Table name: clinic_reviews
#
#  id                        :bigint           not null, primary key
#  average_waiting_time      :integer
#  clinic_selection_criteria :integer
#  review                    :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  clinic_id                 :bigint           not null
#  user_id                   :bigint           not null
#
# Indexes
#
#  index_clinic_reviews_on_clinic_id  (clinic_id)
#  index_clinic_reviews_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (clinic_id => clinics.id)
#  fk_rails_...  (user_id => users.id)
#

require 'test_helper'

class ClinicReviewTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
