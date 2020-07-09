class ReportMOtherEffort < ApplicationRecord
  belongs_to :report
  belongs_to :m_other_effort
end

# == Schema Information
#
# Table name: report_m_other_efforts
#
#  id                :bigint           not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  m_other_effort_id :bigint           not null
#  report_id         :bigint           not null
#
# Indexes
#
#  index_report_m_other_efforts_on_m_other_effort_id  (m_other_effort_id)
#  index_report_m_other_efforts_on_report_id          (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (m_other_effort_id => m_other_efforts.id)
#  fk_rails_...  (report_id => reports.id)
#
