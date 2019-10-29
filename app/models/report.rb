class Report < ApplicationRecord
  # バリデーション
  # validates :title, length: { maximum: 32 }
  validate :validate_treatment_age
  validate :validate_content_length
  validate :validate_content_attachment_byte_size
  validate :validate_content_attachments_count
  
  def validate_treatment_age
    if  treatment_start_age > treatment_end_age
      errors.add(
        :treatment_end_age,
        :treatment_end_age_is_earlier_than_treatment_start_age
      )
    end
  end

  MAX_CONTENT_LENGTH = 30000
  MEGA_BYTES = 3
  ONE_KILOBYTE = 1024
  MAX_CONTENT_ATTACHMENT_BYTE_SIZE = MEGA_BYTES * 1_000 * ONE_KILOBYTE
  MAX_CONTENT_ATTACHMENTS_COUNT = 4

  def validate_content_length
    length = content.to_plain_text.length

    if length > MAX_CONTENT_LENGTH
      errors.add(
        :content,
        :too_long,
        max_content_length: MAX_CONTENT_LENGTH,
        length: length
      )
    end
  end

  def validate_content_attachment_byte_size
    content.body.attachables.grep(ActiveStorage::Blob).each do |attachable|
      if attachable.byte_size > MAX_CONTENT_ATTACHMENT_BYTE_SIZE
        errors.add(
          :base,
          :content_attachment_byte_size_is_too_big,
          max_content_attachment_mega_byte_size: MEGA_BYTES,
          bytes: attachable.byte_size,
          max_bytes: MAX_CONTENT_ATTACHMENT_BYTE_SIZE
        )
      end
    end
  end

  def validate_content_attachments_count
    if content.body.attachables.grep(ActiveStorage::Blob).count > MAX_CONTENT_ATTACHMENTS_COUNT
      errors.add(
        :content,
        :attachments_count_too_big,
        max_content_attachments_count: MAX_CONTENT_ATTACHMENTS_COUNT
      )
    end
  end

  # アクションテキスト
  has_rich_text :content
  
  # ---親---
    # ユーザー
  belongs_to :user

  # ---子---
    # クリニックレビュー
  has_many :clinic_reviews
  accepts_nested_attributes_for :clinic_reviews
    # コメント
  has_many :comments, dependent: :destroy

  # ---多対多---
    # タグ
  has_many :report_tags, dependent: :destroy
  has_many :tags, through: :report_tags

    # サプリ
  has_many :report_supplements, dependent: :destroy
  has_many :supplements, through: :report_supplements
  
    # 不妊原因(男女それぞれ)
  has_many :report_f_infertility_factors, dependent: :destroy
  has_many :f_infertility_factors, through: :report_f_infertility_factors
  has_many :report_m_infertility_factors, dependent: :destroy
  has_many :m_infertility_factors, through: :report_m_infertility_factors

    # 疾患(男女それぞれ)
  has_many :report_f_diseases, dependent: :destroy
  has_many :f_diseases, through: :report_f_diseases
  has_many :report_m_diseases, dependent: :destroy
  has_many :m_diseases, through: :report_m_diseases

    # 手術歴(男女それぞれ)
  has_many :report_f_surgeries, dependent: :destroy
  has_many :f_surgeries, through: :report_f_surgeries
  has_many :report_m_surgeries, dependent: :destroy
  has_many :m_surgeries, through: :report_m_surgeries

    # 卵巣刺激薬剤
  has_many :report_ovarian_stimulations, dependent: :destroy
  has_many :ovarian_stimulations, through: :report_ovarian_stimulations

    # 排卵抑制剤
  has_many :report_ovulation_inhibitors, dependent: :destroy
  has_many :ovulation_inhibitors, through: :report_ovulation_inhibitors

    # 排卵促進剤
  has_many :report_ovulation_inducers, dependent: :destroy
  has_many :ovulation_inducers, through: :report_ovulation_inducers

    # 移植オプション
  has_many :report_transfer_options, dependent: :destroy
  has_many :transfer_options, through: :report_transfer_options




  # treatment_typeの区分値(治療方法)
  HASH_TREATMENT_TYPE = {
    1 => "顕微･体外受精",
    2 => "人工授精",
    3 => "タイミング指導法",
    99 => "その他"
  }

  # current_stateの区分値(現在の状況)
  HASH_CURRENT_STATE = {
    1 => "現在妊娠中",
    2 => "出産した",
    3 => "妊娠または出産に至らず転院(治療継続予定)",
    4 => "不妊治療を辞めた(治療自体を継続しない)"
  }

  # work_styleの区分値(治療中の働き方)
  HASH_WORK_STYLE = {
    1 => "正社員",
    2 => "契約社員",
    3 => "パート",
    4 => "仕事はしていなかった",
    5 => "正社員→退職",
    6 => "正社員→長期休暇",
    7 => "契約社員→退職",
    8 => "パート→退職",
    9 => "リモートワーク等へ切り替え",
    99 => "その他"
  }
  
  # treatment_periodの区分値(休み期間覗く正味治療期間/CL単位)
  HASH_TREATMENT_PERIOD = {
    1 => "〜1ヵ月",
    2 => "〜3ヵ月",
    3 => "〜半年",
    4 => "〜1年",
    5 => "〜1年半",
    6 => "〜2年",
    7 => "〜2年半",
    8 => "〜3年",
    9 => "〜3年半",
    10 => "〜4年",
    11 => "〜4年半",
    12 => "〜5年",
    13 => "〜6年",
    14 => "〜7年",
    15 => "〜8年",
    16 => "〜9年",
    17 => "〜10年",
    99 => "それ以上"
  }

  # bmiの区分値(BMI値)
  HASH_BMI = {
    1 => "18.5未満",
    2 => "18.5〜25未満",
    3 => "25〜30未満",
    4 => "30〜35未満",
    5 => "35〜40未満",
    6 => "40以上"
  }
  
  # amhの区分値(AMH値)
  HASH_AMH = {
    1 => "0.1以下",
    2 => "0.3以下",
    3 => "0.5以下",
    4 => "0.7以下",
    5 => "1.0以下",
    6 => "1.5以下",
    7 => "2.0以下",
    8 => "2.5以下",
    9 => "3.0以下",
    10 => "3.5以下",
    11 => "4.0以下",
    12 => "4.5以下",
    13 => "5.0以下",
    14 => "5.5以下",
    15 => "6.0以下",
    16 => "6.5以下",
    17 => "7.0以下",
    18 => "7.5以下",
    19 => "8.0以下",
    20 => "8.5以下",
    21 => "9.0以下",
    22 => "9.5以下",
    23 => "10.0以下",
    99 => "10.1以上"
  }
  
  # types_of_eggs_and_spermの区分値(卵子と精子の帰属)
  HASH_TYPES_OF_EGGS_AND_SPERM = {
    1 => "自分自身の卵子/精子を用いた",
    2 => "提供卵子を用いた",
    3 => "提供精子を用いた",
    4 => "どちらも提供を受けた",
    5 => "凍結していた自分の未受精卵を用いた",
    6 => "凍結していた自分の精子を用いた",
    99 => "その他"
  }

  # type_of_sairan_cycleの区分値(採卵周期種別)
  HASH_TYPE_OF_SAIRAN_CYCLE = {
    1 => "完全自然",
    2 => "内服薬使用（クロミッド等）",
    3 => "内服薬＋注射",
    4 => "アンタゴニスト法",
    5 => "ロング法",
    6 => "ショート法",
    99 => "不明"
  }

  # types_of_fertilization_methodsの区分値(受精方法)
  HASH_TYPES_OF_FERTILIZATION_METHODS = {
    1 => "体外受精（ふりかけ）",
    2 => "顕微授精",
    3 => "スプリット法",
    99 => "不明"
  }

  # successful_egg_maturityの区分値(妊娠に至った卵子の成熟度)
  HASH_SUCCESSFUL_EGG_MATURITY =  {
    1 => "成熟卵(M2)",
    2 => "未成熟卵(M1)",
    3 => "未成熟卵(GV)",
    99 => "不明"
  }
  
  # successful_embryo_grade_qualityの区分値(妊娠に至った胚の質) ない
  HASH_SUCCESSFUL_EMBRYO_GRADE_QUALITY = {
    1 => "AA",
    2 => "AB",
    3 => "AC",
    4 => "BA",
    5 => "BB",
    6 => "BC",
    7 => "CA",
    8 => "CB",
    9 => "CC",
    99 => "その他",
    100 => "不明"
  }

  # successful_ova_with_ivmの区分値(妊娠に至った卵子へのIVMの有無)
  HASH_SUCCESSFUL_EMBRYO_GRADE_QUALITY = {
    1 => "あり",
    2 => "なし",
    10 => "不明"
  }


  TIMES = "回"
  OR_MORE = "以上"
  OR_LESS = "以下"
  LESS_THAN = "未満"
  PIECES = "個"
  DAY = "日"
  AGE = "歳"
  THE_BEGINNING_OF_AGE = 19
  UNKNOWN = 999
  STR_UNKNOWN = "不明"
  
  # fertility_treatment_numberの区分値(何人目か)
  FERTILITY_TREATMENT_NUMBER_UNIT = "人目不妊"
  FERTILITY_TREATMENT_NUMBER_MAXIMUM = 1000
  FERTILITY_TREATMENT_NUMBER_RANGE = 5
  UPPER_THE_FERTILITY_TREATMENT_NUMBER_RANGE = FERTILITY_TREATMENT_NUMBER_RANGE + 1
  STR_FERTILITY_TREATMENT_NUMBER_MAXIMUM = "#{UPPER_THE_FERTILITY_TREATMENT_NUMBER_RANGE}#{FERTILITY_TREATMENT_NUMBER_UNIT}#{OR_MORE}"

  def str_fertility_treatment_number
    if self.fertility_treatment_number == FERTILITY_TREATMENT_NUMBER_MAXIMUM
      STR_FERTILITY_TREATMENT_NUMBER_MAXIMUM
    elsif self.fertility_treatment_number >= 1 || self.fertility_treatment_number <= FERTILITY_TREATMENT_NUMBER_RANGE
      "#{self.fertility_treatment_number} #{FERTILITY_TREATMENT_NUMBER_UNIT}"
    else
      raise
    end
  end

  def self.make_select_options_fertility_treatment_number
    hash = {}
    (1..FERTILITY_TREATMENT_NUMBER_RANGE).each do |i|
      hash["#{i}#{FERTILITY_TREATMENT_NUMBER_UNIT}"] = i
    end
    hash[STR_FERTILITY_TREATMENT_NUMBER_MAXIMUM] = STR_FERTILITY_TREATMENT_NUMBER_MAXIMUM
    hash
  end

  # number_of_clinicsの区分値(何院目か)
  NUMBER_OF_CLINICS_UNIT = "院目"
  NUMBER_OF_CLINICS_MAXIMUM = 1000
  NUMBER_OF_CLINICS_RANGE = 10
  UPPER_THE_NUMBER_OF_CLINICS_RANGE = NUMBER_OF_CLINICS_RANGE + 1
  STR_NUMBER_OF_CLINICS_MAXIMUM = "#{UPPER_THE_NUMBER_OF_CLINICS_RANGE}#{NUMBER_OF_CLINICS_UNIT}#{OR_MORE}"

  def str_number_of_clinics
    if self.number_of_clinics == NUMBER_OF_CLINICS_MAXIMUM
      STR_NUMBER_OF_CLINICS_MAXIMUM
    elsif self.number_of_clinics >= 1 || self.number_of_clinics <= NUMBER_OF_CLINICS_RANGE
      "#{self.number_of_clinics} #{NUMBER_OF_CLINICS_UNIT}"
    else
      raise
    end
  end

  def self.make_select_options_number_of_clinics
    hash = {}
    (1..NUMBER_OF_CLINICS_RANGE).each do |i|
      hash["#{i}#{NUMBER_OF_CLINICS_UNIT}"] = i
    end
    hash[STR_NUMBER_OF_CLINICS_MAXIMUM] = STR_NUMBER_OF_CLINICS_MAXIMUM
    hash
  end


  # number_of_aihの区分値(実施人工授精実施回数/CL単位)
  NUMBER_OF_AIH_MAXIMUM = 1000
  NUMBER_OF_AIH_RANGE = 10
  UPPER_THE_NUMBER_OF_AIH_RANGE = NUMBER_OF_AIH_RANGE + 1
  STR_NUMBER_OF_AIH_MAXIMUM = "#{UPPER_THE_NUMBER_OF_AIH_RANGE}#{TIMES}#{OR_MORE}"

  def str_number_of_aih
    if self.number_of_aih == NUMBER_OF_AIH_MAXIMUM
      STR_NUMBER_OF_AIH_MAXIMUM
    elsif self.number_of_aih >= 1 || self.number_of_aih <= NUMBER_OF_AIH_RANGE
      "#{self.number_of_aih} #{TIMES}"
    else
      raise
    end
  end

  def self.make_select_options_number_of_aih
    hash = {}
    (1..NUMBER_OF_AIH_RANGE).each do |i|
      hash["#{i}#{TIMES}"] = i
    end
    hash[STR_NUMBER_OF_AIH_MAXIMUM] = STR_NUMBER_OF_AIH_MAXIMUM
    hash
  end

  # treatment_start_ageの区分値(治療開始年齢/CL単位)
  TREATMENT_START_AGE_MAXIMUM = 1000
  TREATMENT_START_AGE_RANGE = 59
  UPPER_THE_TREATMENT_START_AGE_RANGE = TREATMENT_START_AGE_RANGE + 1
  STR_TREATMENT_START_AGE_MAXIMUM = "#{UPPER_THE_TREATMENT_START_AGE_RANGE}#{AGE}#{OR_MORE}"
  STR_TREATMENT_START_AGE_MINIMUM = "#{THE_BEGINNING_OF_AGE}#{AGE}#{OR_LESS}"

  def str_treatment_start_age
    if self.treatment_start_age == TREATMENT_START_AGE_MAXIMUM
      STR_TREATMENT_START_AGE_MAXIMUM
    elsif self.treatment_start_age <= THE_BEGINNING_OF_AGE
      STR_TREATMENT_START_AGE_MINIMUM
    elsif self.treatment_start_age > THE_BEGINNING_OF_AGE || self.treatment_start_age <= TREATMENT_START_AGE_RANGE
      "#{self.treatment_start_age} #{AGE}"
    else
      raise
    end
  end
  
  def self.make_select_options_treatment_start_age
    hash = {}
    (THE_BEGINNING_OF_AGE..TREATMENT_START_AGE_RANGE).each do |i|
      if i == THE_BEGINNING_OF_AGE
        hash[STR_TREATMENT_START_AGE_MINIMUM] = i
      else
        hash["#{i}#{AGE}"] = i
      end
    end
    hash[STR_TREATMENT_START_AGE_MAXIMUM] = STR_TREATMENT_START_AGE_MAXIMUM
    hash
  end

  # treatment_end_ageの区分値(治療終了年齢/CL単位)
  TREATMENT_END_AGE_MAXIMUM = 1000
  TREATMENT_END_AGE_RANGE = 59
  UPPER_THE_TREATMENT_END_AGE_RANGE = TREATMENT_END_AGE_RANGE + 1
  STR_TREATMENT_END_AGE_MAXIMUM = "#{UPPER_THE_TREATMENT_END_AGE_RANGE}#{AGE}#{OR_MORE}"
  STR_TREATMENT_END_AGE_MINIMUM = "#{THE_BEGINNING_OF_AGE}#{AGE}#{OR_LESS}"


  def str_treatment_end_age
    if self.treatment_end_age == TREATMENT_END_AGE_MAXIMUM
      STR_TREATMENT_END_AGE_MAXIMUM
    elsif self.treatment_end_age <= THE_BEGINNING_OF_AGE
      STR_TREATMENT_END_AGE_MINIMUM
    elsif self.treatment_end_age > THE_BEGINNING_OF_AGE || self.treatment_end_age <= TREATMENT_END_AGE_RANGE
      "#{self.treatment_end_age} #{AGE}"
    else
      raise
    end
  end
  
  def self.make_select_options_treatment_end_age
    hash = {}
    (THE_BEGINNING_OF_AGE..TREATMENT_END_AGE_RANGE).each do |i|
      if i == THE_BEGINNING_OF_AGE
        hash[STR_TREATMENT_END_AGE_MINIMUM] = i
      else
        hash["#{i}#{AGE}"] = i
      end
    end
    hash[STR_TREATMENT_END_AGE_MAXIMUM] = STR_TREATMENT_END_AGE_MAXIMUM
    hash
  end

  
  # total_number_of_sairanの区分値(全採卵回数/CL単位)
  TOTAL_NUMBER_OF_SAIRAN_MAXIMUM = 1000
  TOTAL_NUMBER_OF_SAIRAN_RANGE = 20
  UPPER_THE_TOTAL_NUMBER_OF_SAIRAN_RANGE = TOTAL_NUMBER_OF_SAIRAN_RANGE + 1
  STR_TOTAL_NUMBER_OF_SAIRAN_MAXIMUM = "#{UPPER_THE_TOTAL_NUMBER_OF_SAIRAN_RANGE}#{TIMES}#{OR_MORE}"

  def str_total_number_of_sairan
    if self.total_number_of_sairan == TOTAL_NUMBER_OF_SAIRAN_MAXIMUM
      STR_TOTAL_NUMBER_OF_SAIRAN_MAXIMUM
    elsif self.total_number_of_sairan >= 1 || self.total_number_of_sairan <= TOTAL_NUMBER_OF_SAIRAN_RANGE
      "#{self.total_number_of_sairan} #{TIMES}"
    else
      raise
    end
  end

  def self.make_select_options_total_number_of_sairan
    hash = {}
    (1..TOTAL_NUMBER_OF_SAIRAN_RANGE).each do |i|
      hash["#{i}#{TIMES}"] = i
    end

    hash[STR_TOTAL_NUMBER_OF_SAIRAN_MAXIMUM] = STR_TOTAL_NUMBER_OF_SAIRAN_MAXIMUM
    hash
  end

  # total_number_of_transplantsの区分値(全移植回数/CL単位)
  TOTAL_NUMBER_OF_TRANSPLANTS_MAXIMUM = 1000
  TOTAL_NUMBER_OF_TRANSPLANTS_RANGE = 20
  UPPER_THE_TOTAL_NUMBER_OF_TRANSPLANTS_RANGE = TOTAL_NUMBER_OF_TRANSPLANTS_RANGE + 1
  STR_TOTAL_NUMBER_OF_TRANSPLANTS_MAXIMUM = "#{UPPER_THE_TOTAL_NUMBER_OF_TRANSPLANTS_RANGE}#{TIMES}#{OR_MORE}"

  def str_total_number_of_transplants
    if self.total_number_of_transplants == TOTAL_NUMBER_OF_TRANSPLANTS_MAXIMUM
      STR_TOTAL_NUMBER_OF_TRANSPLANTS_MAXIMUM
    elsif self.total_number_of_transplants >= 1 || self.total_number_of_transplants <= TOTAL_NUMBER_OF_TRANSPLANTS_RANGE
      "#{self.total_number_of_transplants} #{TIMES}"
    else
      raise
    end
  end

  def self.make_select_options_total_number_of_transplants
    hash = {}
    (1..TOTAL_NUMBER_OF_TRANSPLANTS_RANGE).each do |i|
      hash["#{i}#{TIMES}"] = i
    end
    hash[STR_TOTAL_NUMBER_OF_TRANSPLANTS_MAXIMUM] = STR_TOTAL_NUMBER_OF_TRANSPLANTS_MAXIMUM
    hash
  end

  # number_of_eggs_collectedの区分値(採卵個数/CL単位)
  NUMBER_OF_EGGS_COLLECTED_MAXIMUM = 1000
  NUMBER_OF_EGGS_COLLECTED_RANGE1 = 100
  NUMBER_OF_EGGS_COLLECTED_RANGE2 = 106
  STR_NUMBER_OF_EGGS_COLLECTED_MAXIMUM = "1,000#{PIECES}#{OR_MORE}"

  def str_total_number_of_eggs_collected
    case self.number_of_eggs_collected
    when UNKNOWN
      STR_UNKNOWN
    when NUMBER_OF_EGGS_COLLECTED_MAXIMUM
      STR_NUMBER_OF_EGGS_COLLECTED_MAXIMUM
    when 1..NUMBER_OF_EGGS_COLLECTED_RANGE1
      "#{self.number_of_eggs_collected} #{PIECES}"
    when NUMBER_OF_EGGS_COLLECTED_RANGE1 + 1
      "101〜150#{PIECES}"
    when NUMBER_OF_EGGS_COLLECTED_RANGE1 + 2
      "151〜200#{PIECES}"
    when NUMBER_OF_EGGS_COLLECTED_RANGE1 + 3
      "201〜300#{PIECES}"
    when NUMBER_OF_EGGS_COLLECTED_RANGE1 + 4
      "301〜400#{PIECES}"
    when NUMBER_OF_EGGS_COLLECTED_RANGE1 + 5
      "401〜500#{PIECES}"
    when NUMBER_OF_EGGS_COLLECTED_RANGE1 + 6
      "501〜999#{PIECES}"
    else
      raise
    end
  end

  def self.make_select_options_number_of_eggs_collected
    hash = {}
    (1..NUMBER_OF_EGGS_COLLECTED_RANGE1).each do |i|
      hash["#{i}#{PIECES}"] = i
    end
    hash["101〜150#{PIECES}"] = "101〜150#{PIECES}"
    hash["151〜200#{PIECES}"] = "101〜150#{PIECES}"
    hash["201〜300#{PIECES}"] = "101〜150#{PIECES}"
    hash["301〜400#{PIECES}"] = "101〜150#{PIECES}"
    hash["401〜500#{PIECES}"] = "101〜150#{PIECES}"
    hash["501〜1,000#{PIECES}"] = "101〜150#{PIECES}"
    hash[STR_NUMBER_OF_EGGS_COLLECTED_MAXIMUM] = STR_NUMBER_OF_EGGS_COLLECTED_MAXIMUM
    hash[STR_UNKNOWN] = STR_UNKNOWN
    hash
  end

  # number_of_fertilized_eggsの区分値(最新採卵周期での受精した個数/CL単位)
  NUMBER_OF_FERTILIZED_EGGS_MAXIMUM = 1000
  NUMBER_OF_FERTILIZED_EGGS_RANGE = 50
  STR_NUMBER_OF_FERTILIZED_EGGS_MAXIMUM = "それ#{OR_MORE}"

  def str_number_of_fertilized_eggs
    if self.number_of_fertilized_eggs == NUMBER_OF_FERTILIZED_EGGS_MAXIMUM
      STR_NUMBER_OF_FERTILIZED_EGGS_MAXIMUM
    elsif self.number_of_fertilized_eggs >= 1 || self.number_of_fertilized_eggs <= NUMBER_OF_FERTILIZED_EGGS_RANGE
      "#{self.number_of_fertilized_eggs} #{PIECES}"
    else
      raise
    end
  end

  def self.make_select_options_number_of_eggs_collected
    hash = {}
    (1..NUMBER_OF_FERTILIZED_EGGS_RANGE).each do |i|
      hash["#{i}#{PIECES}"] = i
    end
    hash[STR_NUMBER_OF_FERTILIZED_EGGS_MAXIMUM] = STR_NUMBER_OF_FERTILIZED_EGGS_MAXIMUM
    hash[STR_UNKNOWN] = STR_UNKNOWN
    hash
  end

  # number_of_frozen_eggsの区分値(最新周期での凍結できた数/CL単位)
  NUMBER_OF_FROZEN_EGGS_MAXIMUM = 1000
  NUMBER_OF_FROZEN_EGGS_RANGE = 50
  STR_NUMBER_OF_FROZEN_EGGS_MAXIMUM = "それ#{OR_MORE}"

  def str_number_of_frozen_eggs
    if self.number_of_frozen_eggs == NUMBER_OF_FROZEN_EGGS_MAXIMUM
      STR_NUMBER_OF_FROZEN_EGGS_MAXIMUM
    elsif self.number_of_frozen_eggs >= 1 || self.number_of_frozen_eggs <= NUMBER_OF_FROZEN_EGGS_RANGE
      "#{self.number_of_frozen_eggs} #{PIECES}"
    else
      raise
    end
  end

  def self.make_select_options_number_of_frozen_eggs
    hash = {}
    (1..NUMBER_OF_FROZEN_EGGS_RANGE).each do |i|
      hash["#{i}#{PIECES}"] = i
    end
    hash[STR_NUMBER_OF_FROZEN_EGGS_MAXIMUM] = STR_NUMBER_OF_FROZEN_EGGS_MAXIMUM
    hash[STR_UNKNOWN] = STR_UNKNOWN
    hash
  end

  # number_of_eggs_storedの区分値(凍結胚の在庫数/CL単位)
  NUMBER_OF_EGGS_STORED_MAXIMUM = 1000
  NUMBER_OF_EGGS_STORED_RANGE = 50
  STR_NUMBER_OF_EGGS_STORED_MAXIMUM = "それ#{OR_MORE}"

  def str_number_of_eggs_stored
    if self.number_of_eggs_stored == NUMBER_OF_EGGS_STORED_MAXIMUM
      STR_NUMBER_OF_EGGS_STORED_MAXIMUM
    elsif self.number_of_eggs_stored >= 1 || self.number_of_eggs_stored <= NUMBER_OF_EGGS_STORED_RANGE
      "#{self.number_of_eggs_stored} #{PIECES}"
    else
      raise
    end
  end

  def self.make_select_options_number_of_eggs_stored
    hash = {}
    (1..NUMBER_OF_EGGS_STORED_RANGE).each do |i|
      hash["#{i}#{PIECES}"] = i
    end
    hash[STR_NUMBER_OF_EGGS_STORED_MAXIMUM] = STR_NUMBER_OF_EGGS_STORED_MAXIMUM
    hash[STR_UNKNOWN] = STR_UNKNOWN
    hash
  end

  # successful_embryo_culture_daysの区分値(妊娠に至った胚の培養日数)
  SUCCESSFUL_EMBRYO_CULTURE_DAYS_MAXIMUM = 1000
  SUCCESSFUL_EMBRYO_CULTURE_DAYS_RANGE = 10
  STR_SUCCESSFUL_EMBRYO_CULTURE_DAYS_MAXIMUM = "それ#{DAY}#{OR_MORE}"

  def str_successful_embryo_culture_days
    case self.successful_embryo_culture_days
    when UNKNOWN
      STR_UNKNOWN
    when SUCCESSFUL_EMBRYO_CULTURE_DAYS_MAXIMUM
      STR_SUCCESSFUL_EMBRYO_CULTURE_DAYS_MAXIMUM
    when 1..SUCCESSFUL_EMBRYO_CULTURE_DAYS_RANGE1
      "#{self.successful_embryo_culture_days} #{DAY}"
    else
      raise
    end
  end

  def self.make_select_options_successful_embryo_culture_days
    hash = {}
    (1..SUCCESSFUL_EMBRYO_CULTURE_DAYS_RANGE).each do |i|
      hash["#{i}#{DAY}"] = i
    end
    hash[STR_SUCCESSFUL_EMBRYO_CULTURE_DAYS_MAXIMUM] = STR_SUCCESSFUL_EMBRYO_CULTURE_DAYS_MAXIMUM
    hash[STR_UNKNOWN] = STR_UNKNOWN
    hash
  end

  # successful_embryo_grade_sizeの区分値(妊娠に至った胚の大きさ) ないsize
  HASH_SUCCESSFUL_EMBRYO_GRADE_SIZE = { "1" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "その他" => 99, "不明" => 100 }
  SUCCESSFUL_EMBRYO_GRADE_SIZE_MAXIMUM = 1000
  SUCCESSFUL_EMBRYO_GRADE_SIZE_RANGE = 10
  STR_SUCCESSFUL_EMBRYO_GRADE_SIZE_MAXIMUM = "それ#{DAY}#{OR_MORE}"

  def str_successful_embryo_grade_size
    case self.successful_embryo_grade_size
    when UNKNOWN
      STR_UNKNOWN
    when SUCCESSFUL_EMBRYO_GRADE_SIZE_MAXIMUM
      STR_SUCCESSFUL_EMBRYO_GRADE_SIZE_MAXIMUM
    when 1..SUCCESSFUL_EMBRYO_GRADE_SIZE_RANGE1
      "#{self.successful_embryo_grade_size} #{DAY}"
    else
      raise
    end
  end

  def self.make_select_options_successful_embryo_grade_size
    hash = {}
    (1..SUCCESSFUL_EMBRYO_GRADE_SIZE_RANGE).each do |i|
      hash["#{i}#{DAY}"] = i
    end
    hash[STR_SUCCESSFUL_EMBRYO_GRADE_SIZE_MAXIMUM] = STR_SUCCESSFUL_EMBRYO_GRADE_SIZE_MAXIMUM
    hash[STR_UNKNOWN] = STR_UNKNOWN
    hash
  end
end

# == Schema Information
#
# Table name: reports
#
#  id                              :bigint           not null, primary key
#  address_at_that_time            :integer
#  amh                             :integer
#  bmi                             :integer
#  content                         :text
#  current_state                   :integer
#  fertility_treatment_number      :integer
#  number_of_aih                   :integer
#  number_of_clinics               :integer
#  number_of_eggs_collected        :integer
#  number_of_eggs_stored           :integer
#  number_of_fertilized_eggs       :integer
#  number_of_frozen_eggs           :integer
#  successful_egg_maturity         :integer
#  successful_embryo_culture_days  :integer
#  successful_embryo_grade_quality :integer
#  successful_embryo_grade_size    :integer
#  successful_ova_with_ivm         :integer
#  total_number_of_sairan          :integer
#  total_number_of_transplants     :integer
#  treatment_end_age               :integer
#  treatment_period                :integer
#  treatment_start_age             :integer
#  treatment_type                  :integer
#  type_of_sairan_cycle            :integer
#  types_of_eggs_and_sperm         :integer
#  types_of_fertilization_methods  :integer
#  work_style                      :integer
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  latest_clinic_review_id         :integer
#  user_id                         :bigint           not null
#
# Indexes
#
#  index_reports_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
