class OvulationInhibitor < ApplicationRecord
  has_many :report_ovulation_inhibitor, dependent: :destroy
  has_many :reports, through: :report_ovulation_inhibitor
end

# == Schema Information
#
# Table name: ovulation_inhibitors
#
#  id         :bigint           not null, primary key
#  name       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
