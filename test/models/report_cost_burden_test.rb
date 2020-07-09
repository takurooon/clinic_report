# == Schema Information
#
# Table name: report_cost_burdens
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  cost_burden_id :bigint           not null
#  report_id      :bigint           not null
#
# Indexes
#
#  index_report_cost_burdens_on_cost_burden_id  (cost_burden_id)
#  index_report_cost_burdens_on_report_id       (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (cost_burden_id => cost_burdens.id)
#  fk_rails_...  (report_id => reports.id)
#
require 'test_helper'

class ReportCostBurdenTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
