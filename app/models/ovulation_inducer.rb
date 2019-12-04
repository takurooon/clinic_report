class OvulationInducer < ApplicationRecord
  has_many :report_ovulation_inducers, dependent: :destroy
  has_many :reports, through: :report_ovulation_inducers

  def str_ovulation_inducers
    return self.name
  end
end

# == Schema Information
#
# Table name: ovulation_inducers
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
