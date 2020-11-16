class FFuninFactor < ApplicationRecord
  has_many :report_f_funin_factors, dependent: :destroy
  has_many :reports, through: :report_f_funin_factors

end
