class FSurgery < ApplicationRecord
  has_many :report_f_surgeries, dependent: :destroy
  has_many :reports, through: :report_f_surgeries

  def str_f_surgery
    return self.name
  end
end

# == Schema Information
#
# Table name: f_surgeries
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
