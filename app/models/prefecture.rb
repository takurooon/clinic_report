class Prefecture < ApplicationRecord
  has_many :cities
  belongs_to :region1
  belongs_to :region2
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
#  region1_id :bigint           not null
#  region2_id :bigint           not null
#
# Indexes
#
#  index_prefectures_on_region1_id  (region1_id)
#  index_prefectures_on_region2_id  (region2_id)
#
# Foreign Keys
#
#  fk_rails_...  (region1_id => region1s.id)
#  fk_rails_...  (region2_id => region2s.id)
#
