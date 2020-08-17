class City < ApplicationRecord
  has_many :clinics
  has_many :reports
  belongs_to :prefecture
end

# == Schema Information
#
# Table name: cities
#
#  id            :bigint           not null, primary key
#  code          :integer
#  name          :string
#  yomigana      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  prefecture_id :bigint           not null
#
# Indexes
#
#  index_cities_on_prefecture_id  (prefecture_id)
#
# Foreign Keys
#
#  fk_rails_...  (prefecture_id => prefectures.id)
#
