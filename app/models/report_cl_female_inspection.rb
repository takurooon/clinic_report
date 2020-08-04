class ReportClFemaleInspection < ApplicationRecord
  belongs_to :report
  belongs_to :cl_female_inspection
end

# == Schema Information
#
# Table name: report_cl_female_inspections
#
#  id                      :bigint           not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  cl_female_inspection_id :bigint           not null
#  report_id               :bigint           not null
#
# Indexes
#
#  index_report_cl_female_inspections_on_cl_female_inspection_id  (cl_female_inspection_id)
#  index_report_cl_female_inspections_on_report_id                (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (cl_female_inspection_id => cl_female_inspections.id)
#  fk_rails_...  (report_id => reports.id)
#