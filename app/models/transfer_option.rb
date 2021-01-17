class TransferOption < ApplicationRecord
  has_many :report_transfer_options, dependent: :destroy
  has_many :reports, through: :report_transfer_options

  def str_transfer_option
    return self.name
  end
end

# == Schema Information
#
# Table name: transfer_options
#
#  id         :bigint           not null, primary key
#  name       :string
#  number     :integer
#  yomigana   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
