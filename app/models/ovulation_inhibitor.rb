class OvulationInhibitor < ApplicationRecord
  has_many :report_ovulation_inhibitors, dependent: :destroy
  has_many :reports, through: :report_ovulation_inhibitors

  def str_ovulation_inhibitors
    return self.name
  end
end

# == Schema Information
#
# Table name: ovulation_inhibitors
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
