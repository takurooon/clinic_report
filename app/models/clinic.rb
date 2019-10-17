class Clinic < ApplicationRecord
  has_many :reports
  has_many :clnic_reviews
end
