class MSupplement < ApplicationRecord
  has_many :report_m_supplements, dependent: :destroy
  has_many :reports, through: :report_m_supplements

  def str_m_supplement
    return self.name
  end
end

# == Schema Information
#
# Table name: m_supplements
#
#  id         :bigint           not null, primary key
#  name       :string
#  yomigana   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
