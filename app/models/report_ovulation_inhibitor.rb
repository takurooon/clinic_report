class ReportOvulationInhibitor < ApplicationRecord
  belongs_to :report
  belongs_to :ovulation_inhibitor
end

# == Schema Information
#
# Table name: report_ovulation_inhibitors
#
#  id                     :bigint           not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  ovulation_inhibitor_id :bigint           not null
#  report_id              :bigint           not null
#
# Indexes
#
#  index_report_ovulation_inhibitors_on_ovulation_inhibitor_id  (ovulation_inhibitor_id)
#  index_report_ovulation_inhibitors_on_report_id               (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (ovulation_inhibitor_id => ovulation_inhibitors.id)
#  fk_rails_...  (report_id => reports.id)
#
