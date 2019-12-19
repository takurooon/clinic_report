class City < ApplicationRecord
  belongs_to :prefecture
end

# == Schema Information
#
# Table name: cities
#
#  id         :bigint           not null, primary key
#  code       :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
