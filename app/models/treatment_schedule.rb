class TreatmentSchedule < ApplicationRecord
  belongs_to :report, inverse_of: :treatment_schedules

  validates :day, presence: true, numericality: true
end

# == Schema Information
#
# Table name: treatment_schedules
#
#  id            :bigint           not null, primary key
#  cycle         :integer
#  day           :integer
#  exam_headline :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  report_id     :bigint           not null
#
# Indexes
#
#  index_treatment_schedules_on_report_id  (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (report_id => reports.id)
#
