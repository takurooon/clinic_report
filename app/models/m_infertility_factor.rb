class MInfertilityFactor < ApplicationRecord
  has_many :report_m_infertility_factors
end

# == Schema Information
#
# Table name: m_infertility_factors
#
#  id         :bigint           not null, primary key
#  name       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
