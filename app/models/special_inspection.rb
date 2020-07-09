class SpecialInspection < ApplicationRecord
  belongs_to :report, inverse_of: :special_inspections

  validates :name, presence: true, numericality: true
end

# == Schema Information
#
# Table name: special_inspections
#
#  id         :bigint           not null, primary key
#  cost       :integer
#  name       :integer          not null
#  place      :integer
#  timing     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  report_id  :bigint           not null
#
# Indexes
#
#  index_special_inspections_on_report_id  (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (report_id => reports.id)
#
