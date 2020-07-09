class ReportClMaleInspection < ApplicationRecord
  belongs_to :report
  belongs_to :cl_male_inspection
end

# == Schema Information
#
# Table name: report_cl_male_inspections
#
#  id                    :bigint           not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  cl_male_inspection_id :bigint           not null
#  report_id             :bigint           not null
#
# Indexes
#
#  index_report_cl_male_inspections_on_cl_male_inspection_id  (cl_male_inspection_id)
#  index_report_cl_male_inspections_on_report_id              (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (cl_male_inspection_id => cl_male_inspections.id)
#  fk_rails_...  (report_id => reports.id)
#
