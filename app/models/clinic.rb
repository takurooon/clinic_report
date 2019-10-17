class Clinic < ApplicationRecord
  has_many :reports
  has_many :clnic_reviews
end

# == Schema Information
#
# Table name: clinics
#
#  id          :bigint           not null, primary key
#  clinic_name :string
#  jsog_code   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
