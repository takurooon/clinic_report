# == Schema Information
#
# Table name: report_f_surgeries
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  f_surgery_id :bigint           not null
#  report_id    :bigint           not null
#
# Indexes
#
#  index_report_f_surgeries_on_f_surgery_id  (f_surgery_id)
#  index_report_f_surgeries_on_report_id     (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (f_surgery_id => f_surgeries.id)
#  fk_rails_...  (report_id => reports.id)
#

require 'test_helper'

class ReportFSurgeryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
