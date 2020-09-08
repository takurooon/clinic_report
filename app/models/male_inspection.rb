class MaleInspection < ApplicationRecord
  has_many :report_male_inspections, dependent: :destroy
  has_many :reports, through: :report_male_inspections

  def str_male_inspection
    return self.name
  end
end

# == Schema Information
#
# Table name: male_inspections
#
#  id         :bigint           not null, primary key
#  name       :string
#  yomigana   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
