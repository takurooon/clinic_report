class ReportTransferMedicine < ApplicationRecord
  belongs_to :report
  belongs_to :transfer_medicine
end

# == Schema Information
#
# Table name: report_transfer_medicines
#
#  id                   :bigint           not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  report_id            :bigint           not null
#  transfer_medicine_id :bigint           not null
#
# Indexes
#
#  index_report_transfer_medicines_on_report_id             (report_id)
#  index_report_transfer_medicines_on_transfer_medicine_id  (transfer_medicine_id)
#
# Foreign Keys
#
#  fk_rails_...  (report_id => reports.id)
#  fk_rails_...  (transfer_medicine_id => transfer_medicines.id)
#
