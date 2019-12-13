class SairanMedicine < ApplicationRecord
  has_many :report_sairan_medicines, dependent: :destroy
  has_many :reports, through: :report_sairan_medicines

  def str_sairan_medicine
    return self.name
  end
end

# == Schema Information
#
# Table name: sairan_medicines
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
