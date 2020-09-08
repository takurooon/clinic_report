class MDisease < ApplicationRecord
  has_many :report_m_diseases, dependent: :destroy
  has_many :reports, through: :report_m_diseases

  def str_m_disease
    return self.name
  end
end

# == Schema Information
#
# Table name: m_diseases
#
#  id         :bigint           not null, primary key
#  name       :string
#  yomigana   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
