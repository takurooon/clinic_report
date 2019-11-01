class ClinicReview < ApplicationRecord
  # バリデーション
  validate :validate_review_length
  
  MAX_REVIEW_LENGTH = 10000
  
  def validate_review_length
    length = review.to_s.length

    if length > MAX_REVIEW_LENGTH
      errors.add(
        :review,
        :too_long,
        max_review_length: MAX_REVIEW_LENGTH,
        length: length
      )
    end
  end

  # ---親---
  belongs_to :report
  belongs_to :user

end

# == Schema Information
#
# Table name: clinic_reviews
#
#  id                        :bigint           not null, primary key
#  average_waiting_time      :integer
#  clinic_selection_criteria :integer
#  review                    :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  clinic_id                 :bigint           not null
#  user_id                   :bigint           not null
#
# Indexes
#
#  index_clinic_reviews_on_clinic_id  (clinic_id)
#  index_clinic_reviews_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (clinic_id => clinics.id)
#  fk_rails_...  (user_id => users.id)
#
