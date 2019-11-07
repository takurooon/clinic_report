class OtherEffort < ApplicationRecord
  has_many :report_effort, dependent: :destroy
  has_many :reports, through: :report_effort
end

# == Schema Information
#
# Table name: other_efforts
#
#  id         :bigint           not null, primary key
#  name       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
