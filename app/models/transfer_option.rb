class TransferOption < ApplicationRecord
  has_many :report_transfer, dependent: :destroy
  has_many :reports, through: :report_transfer
end

# == Schema Information
#
# Table name: transfer_options
#
#  id         :bigint           not null, primary key
#  name       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
