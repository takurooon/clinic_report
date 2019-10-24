class ReportFDisease < ApplicationRecord
  belongs_to :report
  belongs_to :f_disease
end

# == Schema Information
#
# Table name: report_f_diseases
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  f_disease_id :bigint           not null
#  report_id    :bigint           not null
#
# Indexes
#
#  index_report_f_diseases_on_f_disease_id  (f_disease_id)
#  index_report_f_diseases_on_report_id     (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (f_disease_id => f_diseases.id)
#  fk_rails_...  (report_id => reports.id)
#
