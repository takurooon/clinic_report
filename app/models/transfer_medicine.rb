class TransferMedicine < ApplicationRecord
  has_many :report_transfer_medicines, dependent: :destroy
  has_many :reports, through: :report_transfer_medicines

  def str_transfer_medicine
    return self.name
  end
end

# == Schema Information
#
# Table name: transfer_medicines
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
