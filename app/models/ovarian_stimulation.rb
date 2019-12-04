class OvarianStimulation < ApplicationRecord
  has_many :report_ovarian_stimulations, dependent: :destroy
  has_many :reports, through: :report_ovarian_stimulations

  def str_ovarian_stimulation
    return self.name
  end
end

# == Schema Information
#
# Table name: ovarian_stimulations
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
