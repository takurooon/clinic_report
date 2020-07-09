class MOtherEffort < ApplicationRecord
  has_many :report_m_other_efforts, dependent: :destroy
  has_many :reports, through: :report_m_other_efforts

  def str_m_other_effort
    return self.name
  end
end

# == Schema Information
#
# Table name: m_other_efforts
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
