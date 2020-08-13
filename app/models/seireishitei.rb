class Seireishitei < ApplicationRecord
  belongs_to :prefecture
  has_many :cities
end

# == Schema Information
#
# Table name: seireishiteis
#
#  id            :bigint           not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  prefecture_id :bigint
#
# Indexes
#
#  index_seireishiteis_on_prefecture_id  (prefecture_id)
#
# Foreign Keys
#
#  fk_rails_...  (prefecture_id => prefectures.id)
#
