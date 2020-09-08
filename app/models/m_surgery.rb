class MSurgery < ApplicationRecord
  has_many :report_m_surgery, dependent: :destroy
  has_many :reports, through: :report_m_surgery

  def str_m_surgery
    return self.name
  end
end

# == Schema Information
#
# Table name: m_surgeries
#
#  id         :bigint           not null, primary key
#  name       :string
#  yomigana   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
