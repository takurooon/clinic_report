class OtherEffort < ApplicationRecord
  has_many :report_other_efforts, dependent: :destroy
  has_many :reports, through: :report_other_efforts

  def str_other_effort
    return self.name
  end
end

# == Schema Information
#
# Table name: other_efforts
#
#  id         :bigint           not null, primary key
#  name       :string
#  yomigana   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
