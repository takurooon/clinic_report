class FDisease < ApplicationRecord
  has_many :report_f_diseases, dependent: :destroy
  has_many :reports, through: :report_f_diseases
end

# == Schema Information
#
# Table name: f_diseases
#
#  id         :bigint           not null, primary key
#  name       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
