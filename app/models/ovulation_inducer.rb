class OvulationInducer < ApplicationRecord
  has_many :report_ovulation_inducer
end

# == Schema Information
#
# Table name: ovulation_inducers
#
#  id         :bigint           not null, primary key
#  name       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
