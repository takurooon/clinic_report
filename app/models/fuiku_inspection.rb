class FuikuInspection < ApplicationRecord
  has_many :report_fuiku_inspections, dependent: :destroy
  has_many :reports, through: :report_fuiku_inspections
end

# == Schema Information
#
# Table name: fuiku_inspections
#
#  id         :bigint           not null, primary key
#  name       :string
#  number     :integer
#  yomigana   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
