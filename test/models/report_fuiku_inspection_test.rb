# == Schema Information
#
# Table name: report_fuiku_inspections
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  fuiku_inspection_id :bigint           not null
#  report_id           :bigint           not null
#
# Indexes
#
#  index_report_fuiku_inspections_on_fuiku_inspection_id  (fuiku_inspection_id)
#  index_report_fuiku_inspections_on_report_id            (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (fuiku_inspection_id => fuiku_inspections.id)
#  fk_rails_...  (report_id => reports.id)
#
require 'test_helper'

class ReportFuikuInspectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
