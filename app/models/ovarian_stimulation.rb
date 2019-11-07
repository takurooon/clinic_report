class OvarianStimulation < ApplicationRecord
  has_many :report_ovarian_stimulation, dependent: :destroy
  has_many :reports, through: :report_ovarian_stimulation
end

# == Schema Information
#
# Table name: ovarian_stimulations
#
#  id         :bigint           not null, primary key
#  name       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
