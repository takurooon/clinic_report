class Inspection < ApplicationRecord
  has_many :report_inspections, dependent: :destroy
  has_many :inspections, through: :report_inspections

  def str_inspection
    return self.name
  end
end

# == Schema Information
#
# Table name: inspections
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
