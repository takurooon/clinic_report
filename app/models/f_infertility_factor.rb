class FInfertilityFactor < ApplicationRecord
  has_many :report_f_infertility_factors
end

# == Schema Information
#
# Table name: f_infertility_factors
#
#  id         :bigint           not null, primary key
#  name       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
