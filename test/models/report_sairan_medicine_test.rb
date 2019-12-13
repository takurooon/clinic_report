# == Schema Information
#
# Table name: report_sairan_medicines
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  report_id          :bigint           not null
#  sairan_medicine_id :bigint           not null
#
# Indexes
#
#  index_report_sairan_medicines_on_report_id           (report_id)
#  index_report_sairan_medicines_on_sairan_medicine_id  (sairan_medicine_id)
#
# Foreign Keys
#
#  fk_rails_...  (report_id => reports.id)
#  fk_rails_...  (sairan_medicine_id => sairan_medicines.id)
#

require 'test_helper'

class ReportSairanMedicineTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
