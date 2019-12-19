class Region1 < ApplicationRecord
  has_many :prefectures
end

# == Schema Information
#
# Table name: region1s
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
