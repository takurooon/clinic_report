# == Schema Information
#
# Table name: special_inspections
#
#  id          :bigint           not null, primary key
#  cost        :integer
#  explanation :text
#  name        :integer          not null
#  place       :integer
#  timing      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  report_id   :bigint           not null
#
# Indexes
#
#  index_special_inspections_on_report_id  (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (report_id => reports.id)
#
require 'test_helper'

class SpecialInspectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
