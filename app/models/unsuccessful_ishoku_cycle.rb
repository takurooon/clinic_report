class UnsuccessfulIshokuCycle < ApplicationRecord
  belongs_to :report, inverse_of: :unsuccessful_ishoku_cycles

  # numberの区分値(何回目の移植)
  HASH_NUMBER_OF_ISHOKU = {
    1 => "1回目の移植",
    2 => "2回目の移植",
    3 => "3回目の移植",
    4 => "4回目の移植",
    5 => "5回目の移植",
    6 => "6回目の移植",
    7 => "7回目の移植",
    8 => "8回目の移植",
    9 => "9回目の移植",
    10 => "10回目の移植",
    11 => "11回目の移植",
    12 => "12回目の移植",
    13 => "13回目の移植",
    14 => "14回目の移植",
    15 => "15回目の移植",
    16 => "16回目の移植",
    17 => "17回目の移植",
    18 => "18回目の移植",
    19 => "19回目の移植",
    20 => "20回目の移植",
    100 => "不明",
  }

  def str_unsuccessful_ishoku_cycle_number(number)
    return HASH_TOTAL_NUMBER_OF_ISHOKU[number]
  end


  # sairan_ageの区分値(移植時の年齢)
  HASH_ISHOKU_AGE = {
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

  def str_unsuccessful_ishoku_cycle_ishoku_age(age)
    return HASH_ISHOKU_AGE[age]
  end


  # transplant_methodの区分値(移植方法)
  HASH_TRANSPLANT_METHOD = {
    1 => "凍結胚移植",
    4 => "凍結胚移植（2個戻し）",
    2 => "新鮮胚移植",
    3 => "2段階移植（初期胚&胚盤胞）",
    99 => "その他",
    100 => "不明"
  }

  def str_unsuccessful_ishoku_cycle_transplant_method(method)
    return HASH_TRANSPLANT_METHOD[method]
  end

  # ishoku_typeの区分値(移植周期のタイプ)
  HASH_ISHOKU_TYPE = {
    1 => "自然周期",
    2 => "ホルモン補充周期",
    99 => "その他",
    100 => "不明",
  }

  def str_unsuccessful_ishoku_cycle_ishoku_type(type)
    return HASH_ISHOKU_TYPE[type]
  end
end

# == Schema Information
#
# Table name: unsuccessful_ishoku_cycles
#
#  id                :bigint           not null, primary key
#  ishoku_age        :integer
#  ishoku_type       :integer
#  memo              :text
#  number            :integer
#  transplant_method :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  report_id         :bigint           not null
#
# Indexes
#
#  index_unsuccessful_ishoku_cycles_on_report_id  (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (report_id => reports.id)
#
