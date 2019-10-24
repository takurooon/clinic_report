class ReportMDisease < ApplicationRecord
  belongs_to :report
  belongs_to :m_disease
end

# == Schema Information
#
# Table name: report_m_diseases
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  m_disease_id :bigint           not null
#  report_id    :bigint           not null
#
# Indexes
#
#  index_report_m_diseases_on_m_disease_id  (m_disease_id)
#  index_report_m_diseases_on_report_id     (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (m_disease_id => m_diseases.id)
#  fk_rails_...  (report_id => reports.id)
#
