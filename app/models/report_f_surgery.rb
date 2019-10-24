class ReportFSurgery < ApplicationRecord
  belongs_to :report
  belongs_to :f_surgery
end

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
