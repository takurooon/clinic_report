# == Schema Information
#
# Table name: clinics
#
#  id          :bigint           not null, primary key
#  clinic_name :string
#  jsog_code   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class ClinicTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
