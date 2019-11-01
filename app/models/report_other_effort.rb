class ReportOtherEffort < ApplicationRecord
  belongs_to :report
  belongs_to :other_effort
end

# == Schema Information
#
# Table name: report_other_efforts
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  other_effort_id :bigint           not null
#  report_id       :bigint           not null
#
# Indexes
#
#  index_report_other_efforts_on_other_effort_id  (other_effort_id)
#  index_report_other_efforts_on_report_id        (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (other_effort_id => other_efforts.id)
#  fk_rails_...  (report_id => reports.id)
#
