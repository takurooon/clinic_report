class ClMaleInspection < ApplicationRecord
  has_many :report_cl_male_inspections, dependent: :destroy
  has_many :reports, through: :report_cl_male_inspections

  def str_cl_male_inspection
    return self.name
  end
end

# == Schema Information
#
# Table name: cl_male_inspections
#
#  id         :bigint           not null, primary key
#  name       :string
#  yomigana   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
