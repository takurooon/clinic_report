class Clinic < ApplicationRecord
  has_many :reports
  has_many :clnic_reviews
end

# == Schema Information
#
# Table name: clinics
#
#  id                   :bigint           not null, primary key
#  address1             :string
#  address2             :string
#  fujinkashuyo         :integer
#  hai_ranshi_toketsu   :integer
#  ivf                  :integer
#  jsog_code            :integer
#  kenbijusei           :integer
#  name                 :string
#  post_code            :string
#  senkoishido          :integer
#  shusanki             :integer
#  social_ranshitoketsu :integer
#  teikyoseishi_aih     :integer
#  tel                  :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
