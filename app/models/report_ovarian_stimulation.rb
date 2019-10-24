class ReportOvarianStimulation < ApplicationRecord
  belongs_to :report
  belongs_to :ovarian_stimulation
end

# == Schema Information
#
# Table name: report_ovarian_stimulations
#
#  id                     :bigint           not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  ovarian_stimulation_id :bigint           not null
#  report_id              :bigint           not null
#
# Indexes
#
#  index_report_ovarian_stimulations_on_ovarian_stimulation_id  (ovarian_stimulation_id)
#  index_report_ovarian_stimulations_on_report_id               (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (ovarian_stimulation_id => ovarian_stimulations.id)
#  fk_rails_...  (report_id => reports.id)
#
