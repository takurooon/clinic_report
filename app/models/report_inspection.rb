class ReportInspection < ApplicationRecord
  belongs_to :report
  belongs_to :inspection
end

# == Schema Information
#
# Table name: report_inspections
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  inspection_id :bigint           not null
#  report_id     :bigint           not null
#
# Indexes
#
#  index_report_inspections_on_inspection_id  (inspection_id)
#  index_report_inspections_on_report_id      (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (inspection_id => inspections.id)
#  fk_rails_...  (report_id => reports.id)
#
