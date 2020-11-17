class FFuninFactor < ApplicationRecord
  has_many :report_f_funin_factors, dependent: :destroy
  has_many :reports, through: :report_f_funin_factors
end

# == Schema Information
#
# Table name: f_funin_factors
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
