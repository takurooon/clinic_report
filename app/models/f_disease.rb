class FDisease < ApplicationRecord
  has_many :report_f_diseases, dependent: :destroy
  has_many :reports, through: :report_f_diseases

  def str_f_disease
    return self.name
  end
end

# == Schema Information
#
# Table name: f_diseases
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
