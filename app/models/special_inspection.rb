class SpecialInspection < ApplicationRecord
  belongs_to :report, inverse_of: :special_inspections

  validates :name, presence: true, numericality: true


  # special_inspectionの区分値(特殊検査)
  # この順番を変えたら必ずreportコントローラのshow部分を確認すること！
  # name
  HASH_SPECIAL_INSPECTION_NAME = {
    1 => "エラ(ERA)",
    2 => "エマ(EMMA)",
    3 => "アリス(ALICE)",
    4 => "トリオ(TORIO)",
    5 => "ERPeak",
    6 => "子宮内膜組織診",
    7 => "子宮内フローラ",
    8 => "慢性子宮内膜炎(CD138･BCE)",
    9 => "子宮鏡検査",
    10 => "染色体検査",
    11 => "CA125",
    12 => "MRI",
    13 => "ビタミンD検査",
    14 => "銅亜鉛検査",
    99 => "その他",
  }

  def str_special_inspection_name(name)
    return HASH_SPECIAL_INSPECTION_NAME[name]
  end

  # place
  HASH_SPECIAL_INSPECTION_PLACE = {
    1 => "このクリニックで",
    2 => "別のクリニックで",
  }

  def str_special_inspection_place(place)
    return HASH_SPECIAL_INSPECTION_PLACE[place]
  end
end

# == Schema Information
#
# Table name: special_inspections
#
#  id         :bigint           not null, primary key
#  cost       :integer
#  memo       :text
#  name       :integer          not null
#  place      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  report_id  :bigint           not null
#
# Indexes
#
#  index_special_inspections_on_report_id  (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (report_id => reports.id)
#
