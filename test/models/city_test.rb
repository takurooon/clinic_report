# == Schema Information
#
# Table name: cities
#
#  id              :bigint           not null, primary key
#  code            :integer
#  name            :string
#  yomigana        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  prefecture_id   :bigint           not null
#  seireishitei_id :bigint           not null
#
# Indexes
#
#  index_cities_on_prefecture_id    (prefecture_id)
#  index_cities_on_seireishitei_id  (seireishitei_id)
#
# Foreign Keys
#
#  fk_rails_...  (prefecture_id => prefectures.id)
#  fk_rails_...  (seireishitei_id => seireishiteis.id)
#

require 'test_helper'

class CityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
