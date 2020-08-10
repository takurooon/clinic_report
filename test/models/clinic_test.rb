# == Schema Information
#
# Table name: clinics
#
#  id                   :bigint           not null, primary key
#  address1             :string
#  address2             :string
#  current_status       :integer
#  fujinkashuyo         :integer
#  hai_ranshi_toketsu   :integer
#  ivf                  :integer
#  japco                :integer
#  jis_art              :integer
#  jsog_code            :integer
#  kenbijusei           :integer
#  name                 :string
#  pgt                  :integer
#  post_code            :string
#  senkoishido          :integer
#  shusanki             :integer
#  social_ranshitoketsu :integer
#  teikyoseishi_aih     :integer
#  tel                  :string
#  yomigana             :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  city_id              :bigint           not null
#  prefecture_id        :bigint           not null
#
# Indexes
#
#  index_clinics_on_city_id        (city_id)
#  index_clinics_on_prefecture_id  (prefecture_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (prefecture_id => prefectures.id)
#

require 'test_helper'

class ClinicTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
