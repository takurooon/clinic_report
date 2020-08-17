class Prefecture < ApplicationRecord
  has_many :cities
  has_many :reports
  has_many :clinics
  belongs_to :region1
end

# == Schema Information
#
# Table name: prefectures
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  region1_id :bigint           not null
#
# Indexes
#
#  index_prefectures_on_region1_id  (region1_id)
#
# Foreign Keys
#
#  fk_rails_...  (region1_id => region1s.id)
#
