# == Schema Information
#
# Table name: unsuccessful_ishoku_cycles
#
#  id                :bigint           not null, primary key
#  ishoku_age        :integer
#  ishoku_type       :integer
#  memo              :text
#  number            :integer
#  transplant_method :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  report_id         :bigint           not null
#
# Indexes
#
#  index_unsuccessful_ishoku_cycles_on_report_id  (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (report_id => reports.id)
#
require 'test_helper'

class UnsuccessfulIshokuCycleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
