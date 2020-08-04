class ReportMaleInspection < ApplicationRecord
  belongs_to :report
  belongs_to :male_inspection
end

# == Schema Information
#
# Table name: report_male_inspections
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  male_inspection_id :bigint           not null
#  report_id          :bigint           not null
#
# Indexes
#
#  index_report_male_inspections_on_male_inspection_id  (male_inspection_id)
#  index_report_male_inspections_on_report_id           (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (male_inspection_id => male_inspections.id)
#  fk_rails_...  (report_id => reports.id)
#