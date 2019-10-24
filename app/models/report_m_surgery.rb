class ReportMSurgery < ApplicationRecord
  belongs_to :report
  belongs_to :m_surgery
end

# == Schema Information
#
# Table name: report_m_surgeries
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  m_surgery_id :bigint           not null
#  report_id    :bigint           not null
#
# Indexes
#
#  index_report_m_surgeries_on_m_surgery_id  (m_surgery_id)
#  index_report_m_surgeries_on_report_id     (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (m_surgery_id => m_surgeries.id)
#  fk_rails_...  (report_id => reports.id)
#
