class Report < ApplicationRecord
  belongs_to :user
  has_many :clinic_reviews
end
