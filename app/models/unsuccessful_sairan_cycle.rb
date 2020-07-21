class UnsuccessfulSairanCycle < ApplicationRecord
  belongs_to :report, inverse_of: :unsuccessful_sairan_cycles

  # numberの区分値(何回目の採卵)
  HASH_NUMBER_OF_SAIRAN = {
    1 => "1回目の採卵",
    2 => "2回目の採卵",
    3 => "3回目の採卵",
    4 => "4回目の採卵",
    5 => "5回目の採卵",
    6 => "6回目の採卵",
    7 => "7回目の採卵",
    8 => "8回目の採卵",
    9 => "9回目の採卵",
    10 => "10回目の採卵",
    11 => "11回目の採卵",
    12 => "12回目の採卵",
    13 => "13回目の採卵",
    14 => "14回目の採卵",
    15 => "15回目の採卵",
    16 => "16回目の採卵",
    17 => "17回目の採卵",
    18 => "18回目の採卵",
    19 => "19回目の採卵",
    20 => "20回目の採卵",
    100 => "不明",
  }

  def str_unsuccessful_sairan_cycle_number(number)
    return HASH_NUMBER_OF_SAIRAN[number]
  end

  # sairan_ageの区分値(採卵時の年齢)
  HASH_SAIRAN_AGE = {
    19 => "19歳以下",
    20 => "20歳",
    21 => "21歳",
    22 => "22歳",
    23 => "23歳",
    24 => "24歳",
    25 => "25歳",
    26 => "26歳",
    27 => "27歳",
    28 => "28歳",
    29 => "29歳",
    30 => "30歳",
    31 => "31歳",
    32 => "32歳",
    33 => "33歳",
    34 => "34歳",
    35 => "35歳",
    36 => "36歳",
    37 => "37歳",
    38 => "38歳",
    39 => "39歳",
    40 => "40歳",
    41 => "41歳",
    42 => "42歳",
    43 => "43歳",
    44 => "44歳",
    45 => "45歳",
    46 => "46歳",
    47 => "47歳",
    48 => "48歳",
    49 => "49歳",
    50 => "50歳",
    51 => "51歳",
    52 => "52歳",
    53 => "53歳",
    54 => "54歳",
    55 => "55歳",
    56 => "56歳",
    57 => "57歳",
    58 => "58歳",
    59 => "59歳",
    60 => "60歳以上",
    100 => "不明",
  }

  def str_unsuccessful_sairan_cycle_sairan_age(age)
    return HASH_SAIRAN_AGE[age]
  end

  # type_of_ovarian_stimulationの区分値()
  HASH_TYPE_OF_OVARIAN_STIMULATION = {
    1 => "刺激なし",
    2 => "低刺激",
    3 => "中刺激",
    4 => "高刺激",
    99 => "その他",
    100 => "不明"
  }

  def str_unsuccessful_sairan_cycle_type_of_ovarian_stimulation(type)
    return HASH_TYPE_OF_OVARIAN_STIMULATION[type]
  end

  # 個数
  HASH_NUMBER_OF_EGGS = {
    1 => "1個",
    2 => "2個",
    3 => "3個",
    4 => "4個",
    5 => "5個",
    6 => "6個",
    7 => "7個",
    8 => "8個",
    9 => "9個",
    10 => "10個",
    11 => "11個",
    12 => "12個",
    13 => "13個",
    14 => "14個",
    15 => "15個",
    16 => "16個",
    17 => "17個",
    18 => "18個",
    19 => "19個",
    20 => "20個",
    21 => "21個",
    22 => "22個",
    23 => "23個",
    24 => "24個",
    25 => "25個",
    26 => "26個",
    27 => "27個",
    28 => "28個",
    29 => "29個",
    30 => "30個",
    31 => "31個",
    32 => "32個",
    33 => "33個",
    34 => "34個",
    35 => "35個",
    36 => "36個",
    37 => "37個",
    38 => "38個",
    39 => "39個",
    40 => "40個",
    41 => "41個",
    42 => "42個",
    43 => "43個",
    44 => "44個",
    45 => "45個",
    46 => "46個",
    47 => "47個",
    48 => "48個",
    49 => "49個",
    50 => "50個",
    99 => "それ以上",
    100 => "不明",
  }

  def str_unsuccessful_sairan_cycle_number_of_eggs_collected(collected)
    return HASH_NUMBER_OF_EGGS[collected]
  end

  def str_unsuccessful_sairan_cycle_number_of_fertilized_eggs(fertilized_eggs)
    return HASH_NUMBER_OF_EGGS[fertilized_eggs]
  end

  def str_unsuccessful_sairan_cycle_number_of_transferable_embryos(transferable)
    return HASH_NUMBER_OF_EGGS[transferable]
  end

  def str_unsuccessful_sairan_cycle_number_of_frozen_eggs(frozen)
    return HASH_NUMBER_OF_EGGS[frozen]
  end
end

# == Schema Information
#
# Table name: unsuccessful_sairan_cycles
#
#  id                             :bigint           not null, primary key
#  memo                           :text
#  number                         :integer
#  number_of_eggs_collected       :integer
#  number_of_fertilized_eggs      :integer
#  number_of_frozen_eggs          :integer
#  number_of_transferable_embryos :integer
#  sairan_age                     :integer
#  type_of_ovarian_stimulation    :integer
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  report_id                      :bigint           not null
#
# Indexes
#
#  index_unsuccessful_sairan_cycles_on_report_id  (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (report_id => reports.id)
#
