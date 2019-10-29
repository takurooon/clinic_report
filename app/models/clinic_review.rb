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
  belongs_to :clinic

  
  # costの区分値(CLでの費用訴額)
  HASH_COST = {
    1 => "10万円未満",
    2 => "10〜30万円未満",
    3 => "30〜50万円未満",
    4 => "50〜100万円未満",
    5 => "100〜150万円未満",
    6 => "150〜200万円未満",
    7 => "200〜250万円未満",
    8 => "250〜300万円未満",
    9 => "300〜350万円未満",
    10 => "350〜400万円未満",
    11 => "400〜450万円未満",
    12 => "450〜500万円未満",
    13 => "500〜550万円未満",
    14 => "550〜600万円未満",
    15 => "600〜650万円未満",
    16 => "650〜700万円未満",
    17 => "700〜750万円未満",
    18 => "750〜800万円未満",
    19 => "800〜850万円未満",
    20 => "850〜900万円未満",
    21 => "900〜950万円未満",
    22 => "950〜1,000万円未満",
    23 => "1,000〜1,500万円未満",
    24 => "1,500〜2,000万円未満",
    99 => "2,000万円以上"
  }

  # credit_card_validityの区分値(クレジットカード使用可否)
  HASH_CREDIT_CARD_VALIDITY = {
    1 => "可",
    2 => "不可",
    3 => "一定の金額から使用可能",
    99 => "その他"
    }
  
  # verage_waiting_timeの区分値(クリニックでの平均待ち時間)
  HASH_VERAGE_WAITING_TIME = {
    1 => "〜1時間",
    2 => "〜2時間",
    3 => "〜3時間",
    4 => "〜4時間",
    5 => "〜5時間",
    99 => "それ以上"
  }

  # clinic_selection_criteriaの区分値(このクリニック選定理由)
  HASH_CLINIC_SELECTION_CRITERIA = {
    1 => "自宅から近かったから",
    2 => "職場から近かったから",
    3 => "口コミがよかったから",
    4 => "料金が手頃だったから",
    5 => "以前に通ったことがあったから",
    99 => "それ以上"
    }
end

# == Schema Information
#
# Table name: clinic_reviews
#
#  id                        :bigint           not null, primary key
#  average_waiting_time      :integer
#  clinic_selection_criteria :integer
#  cost                      :integer
#  credit_card_validity      :integer
#  review                    :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  clinic_id                 :bigint           not null
#  report_id                 :bigint           not null
#
# Indexes
#
#  index_clinic_reviews_on_clinic_id  (clinic_id)
#  index_clinic_reviews_on_report_id  (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (clinic_id => clinics.id)
#  fk_rails_...  (report_id => reports.id)
#
