class MSurgery < ApplicationRecord
  has_many :report_m_surgery, dependent: :destroy
  has_many :reports, through: :report_m_surgery
end

# == Schema Information
#
# Table name: m_surgeries
#
#  id         :bigint           not null, primary key
#  name       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
