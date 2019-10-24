class ReportTransferOption < ApplicationRecord
  belongs_to :report
  belongs_to :transfer_option
end

# == Schema Information
#
# Table name: report_transfer_options
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  report_id          :bigint           not null
#  transfer_option_id :bigint           not null
#
# Indexes
#
#  index_report_transfer_options_on_report_id           (report_id)
#  index_report_transfer_options_on_transfer_option_id  (transfer_option_id)
#
# Foreign Keys
#
#  fk_rails_...  (report_id => reports.id)
#  fk_rails_...  (transfer_option_id => transfer_options.id)
#
