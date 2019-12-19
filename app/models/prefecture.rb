class Prefecture < ApplicationRecord
  has_many :cities
end

# == Schema Information
#
# Table name: prefectures
#
#  id         :bigint           not null, primary key
#  code       :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
