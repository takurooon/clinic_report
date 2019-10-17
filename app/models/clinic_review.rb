class ClinicReview < ApplicationRecord
  belongs_to :report
  belongs_to :clinic
end
