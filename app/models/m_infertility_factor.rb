class MInfertilityFactor < ApplicationRecord
  has_many :report_m_infertility_factors, dependent: :destroy
  has_many :reports, through: :report_m_infertility_factors

  def str_m_infertility_factor
    return self.name
  end
end

# == Schema Information
#
# Table name: m_infertility_factors
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
