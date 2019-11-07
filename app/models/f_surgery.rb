class FSurgery < ApplicationRecord
  has_many :report_f_surgery, dependent: :destroy
  has_many :reports, through: :report_f_surgery
end

# == Schema Information
#
# Table name: f_surgeries
#
#  id         :bigint           not null, primary key
#  name       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
