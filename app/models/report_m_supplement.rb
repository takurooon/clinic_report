class ReportMSupplement < ApplicationRecord
  belongs_to :report
  belongs_to :m_supplement
end

# == Schema Information
#
# Table name: report_m_supplements
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  m_supplement_id :bigint           not null
#  report_id       :bigint           not null
#
# Indexes
#
#  index_report_m_supplements_on_m_supplement_id  (m_supplement_id)
#  index_report_m_supplements_on_report_id        (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (m_supplement_id => m_supplements.id)
#  fk_rails_...  (report_id => reports.id)
#
