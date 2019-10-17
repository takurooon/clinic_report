class Report < ApplicationRecord
  belongs_to :user
  belongs_to :clinic
  has_many :clnic_reviews
end
