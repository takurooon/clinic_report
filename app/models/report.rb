class Report < ApplicationRecord
  # バリデーション
  # validates :title, length: { maximum: 32 }
  validate :validate_content_attachment_byte_size
  validate :validate_content_attachments_count
  validate :validate_content_length
  
  # 画像サイズ変更はMAGA_BYTESを変える
  MEGA_BYTES = 3
  ONE_KILOBYTE = 1024
  MAX_CONTENT_ATTACHMENT_BYTE_SIZE = MEGA_BYTES * 1_000 * ONE_KILOBYTE
  MAX_CONTENT_LENGTH = 30000
  MAX_CONTENT_ATTACHMENTS_COUNT = 4

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



  # fertility_treatment_numberの区分値(何人目か)
  HASH_FERTILITY_TREATMENT_NUMBER = { 1 => "1人目", 2 => "2人目", 3 => "3人目", 4 => "4人目", 5 => "5人目", 99 => "6人目以上" }

  # treatment_typeの区分値(治療方法)
  HUSH_TREATMENT_TYPE = { 1 => "顕微･体外受精", 2 => "人工授精", 3 => "タイミング指導法", 99 => "その他" }

  # current_stateの区分値(現在の状況)
  HUSH_CURRENT_STATE = { "現在妊娠中" => 1, "出産した" => 2, "妊娠または出産に至らず転院(治療継続予定)" => 3, "不妊治療を辞めた(治療自体を継続しない)" => 4 }

  # work_styleの区分値(治療中の働き方)
  HUSH_WORK_STYLE =  { "正社員" => 1, "契約社員" => 2, "パート" => 3, "仕事はしていなかった" => 4, "正社員→退職" => 5, "正社員→長期休暇" => 6, "契約社員→退職" => 7, "パート→退職" => 8, "リモートワーク等へ切り替え" => 9, "その他" => 99 }
  
  # number_of_clinicsの区分値(何院目か)
  HUSH_NUMBER_OF_CLINICS = { "1院目" => 1, "2院目" => 2, "3院目" => 3, "4院目" => 4, "5院目" => 5, "6院目" => 6, "7院目" => 7, "8院目" => 8, "9院目" => 9, "10院目" => 10, "それ以上" => 99 }

  # number_of_aihの区分値(実施人工授精実施回数/CL単位)
  HUSH_NUMBER_OF_AIH = { "1回" => 1, "2回" => 2, "3回" => 3, "4回" => 4, "5回" => 5, "6回" => 6, "7回" => 7, "8回" => 8, "9回" => 9, "10回" => 10, "10回以上" => 99 }

  # reatment_start_age, reatment_end_ageの区分値(治療開始と終了年齢/CL単位)
  HUSH_TREATMENT_START_END_AGE = { "20歳未満" => 19, "20歳" => 20, "21歳" => 21, "22歳" => 22, "23歳" => 23, "24歳" => 24, "25歳" => 25, "26歳" => 26, "27歳" => 27, "28歳" => 28, "29歳" => 29, "30歳" => 30, "31歳" => 31, "32歳" => 32, "33歳" => 33, "34歳" => 34, "35歳" => 35, "36歳" => 36, "37歳" => 37, "38歳" => 38, "39歳" => 39, "40歳" => 40, "41歳" => 41, "42歳" => 42, "43歳" => 43, "44歳" => 44, "45歳" => 45, "46歳" => 46, "47歳" => 47, "48歳" => 48, "49歳" => 49, "50歳" => 50, "51歳" => 51, "52歳" => 52, "53歳" => 53, "54歳" => 54, "55歳" => 55, "56歳" => 56, "57歳" => 57, "58歳" => 58, "59歳" => 59, "60歳以上" => 99 }

  # treatment_periodの区分値(休み期間覗く正味治療期間/CL単位)
  HUSH_TREATMENT_PERIOD = { "〜1ヵ月" => 1, "〜3ヵ月" => 2, "〜半年" => 3, "〜1年" => 4, "〜1年半" => 5, "〜2年" => 6, "〜2年半" => 7, "〜3年" => 8, "〜3年半" => 9, "〜4年" => 10, "〜4年半" => 11, "〜5年" => 12, "〜6年" => 13, "〜7年" => 14, "〜8年" => 15, "〜9年" => 16, "〜10年" => 17, "それ以上" => 99 }
  
  # amhの区分値(AMH値)
  HUSH_AMH = { "0.1以下" => 1, "0.3以下" => 2, "0.5以下" => 3, "0.7以下" => 4, "1.0以下" => 5, "1.5以下" => 6, "2.0以下" => 7, "2.5以下" => 8, "3.0以下" => 9, "3.5以下" => 10, "4.0以下" => 11, "4.5以下"  => 12, "5.0以下" => 13, "5.5以下" => 14, "6.0以下" => 15, "6.5以下" => 16, "7.0以下" => 17, "7.5以下" => 18, "8.0以下" => 19, "8.5以下" => 20, "9.0以下" => 21, "9.5以下" => 22, "10.0以下" => 23, "10.1以上" => 99 }
  
  # bmiの区分値(BMI値)
  HUSH_BMI = { "18.5未満" => 1, "18.5〜25未満" => 2, "25〜30未満" => 3, "30〜35未満" => 4, "35〜40未満" => 5, "40以上" => 6 }
  
  # types_of_eggs_and_spermの区分値(卵子と精子の帰属)
  HUSH_TYPES_OF_EGGS_AND_SPERM = { "自分自身の卵子/精子を用いた" => 1, "提供卵子を用いた" => 2, "提供精子を用いた" => 3, "どちらも提供を受けた" => 4, "凍結していた自分の未受精卵を用いた" => 5, "凍結していた自分の精子を用いた" => 6, "その他" => 99 }
  
  # total_number_of_sairan, total_number_of_transplantsの区分値(全採卵回数/CL単位、移植回数/CL単位)
  HUSH_TOTAL_NUMBER_OF_SAIRAN_TRANSPLANTS =  { "1回" => 1, "2回" => 2, "3回" => 3, "4回" => 4, "5回" => 5, "6回" => 6, "7回" => 7, "8回" => 8, "9回" => 9, "10回" => 10, "11回" => 11, "12回"  => 12, "13回" => 13, "14回" => 14, "15回" => 15, "16回" => 16, "17回" => 17, "18回" => 18, "19回" => 19, "20回" => 20, "それ以上" => 99 }

  # number_of_eggs_collectedの区分値(採卵個数/CL単位)
  # HUSH_NUMBER_OF_EGGS_COLLECTED = { "1個" => 1, "2個" => 2, "3個" => 3, "4個" => 4, "5個" => 5, "6個" => 6, "7個" => 7, "8個" => 8, "9個" => 9, "10個" => 10, "11個" => 11, "12個"  => 12, "13個" => 13, "14個" => 14, "15個" => 15, "16個" => 16, "17個" => 17, "18個" => 18, "19個" => 19, "20個" => 20, "21個" => 21, "22個" => 22, "23個" => 23, "24個" => 24, "25個" => 25, "26個" => 26, "27個" => 27, "28個" => 28, "29個" => 29, "30個" => 30, "31個" => 31, "32個"  => 32, "33個" => 33, "34個" => 34, "35個" => 35, "36個" => 36, "37個" => 37, "38個" => 38, "39個" => 39, "40個" => 40, "41個" => 41, "42個" => 42, "43個" => 43, "44個" => 44, "45個" => 45, "46個" => 46, "47個" => 47, "48個" => 48, "49個" => 49, "50個" => 50, "51個" => 51, "52個"  => 52, "53個" => 53, "54個" => 54, "55個" => 55, "56個" => 56, "57個" => 57, "58個" => 58, "59個" => 59, "60個" => 60, "61個" => 61, "62個" => 62, "63個" => 63, "64個" => 64, "65個" => 65, "66個" => 66, "67個" => 67, "68個" => 68, "69個" => 69, "70個" => 70, "11個" => 71, "72個"  => 72, "73個" => 73, "74個" => 74, "75個" => 75, "76個" => 76, "77個" => 77, "78個" => 78, "79個" => 79, "80個" => 80, "81個" => 81, "82個" => 82, "83個" => 83, "84個" => 84, "85個" => 85, "86個" => 86, "87個" => 87, "88個" => 88, "89個" => 89, "90個" => 90, "91個" => 91, "92個"  => 92, "93個" => 93, "94個" => 94, "95個" => 95, "96個" => 96, "97個" => 97, "98個" => 98, "99個" => 99, "100個" => 100, "101〜150個" => 101, "151〜200個" => 102, "201〜300個" => 103, "301〜400個" => 104, "401〜500個" => 105, "501〜1,000個" => 106, "それ以上" => 999 }

  # type_of_sairan_cycleの区分値(採卵周期種別)
  HUSH_TYPE_OF_SAIRAN_CYCLE = { "完全自然" => 1, "内服薬使用（クロミッド等）" => 2, "内服薬＋注射" => 3, "4個" => 4, "アンタゴニスト法" => 5, "ロング法" => 6, "ショート法" => 7, "不明" => 99 }

  # types_of_fertilization_methodsの区分値(受精方法)
  HUSH_TYPES_OF_FERTILIZATION_METHODS = { "体外受精（ふりかけ）" => 1, "顕微授精" => 2, "スプリット法" => 3, "不明" => 99 }
  
  # number_of_fertilized_eggs, number_of_frozen_eggs, number_of_eggs_storedの区分値(最新採卵周期での受精した個数、最新周期での凍結できた数、凍結胚の在庫数/CL単位)
  HUSH_NUMBER_OF_FERTILIZED_FROZEN_STORED_EGGS = { "1個" => 1, "2個" => 2, "3個" => 3, "4個" => 4, "5個" => 5, "6個" => 6, "7個" => 7, "8個" => 8, "9個" => 9, "10個" => 10, "11個" => 11, "12個"  => 12, "13個" => 13, "14個" => 14, "15個" => 15, "16個" => 16, "17個" => 17, "18個" => 18, "19個" => 19, "20個" => 20, "21個" => 21, "22個" => 22, "23個" => 23, "24個" => 24, "25個" => 25, "26個" => 26, "27個" => 27, "28個" => 28, "29個" => 29, "30個" => 30, "31個" => 31, "32個"  => 32, "33個" => 33, "34個" => 34, "35個" => 35, "36個" => 36, "37個" => 37, "38個" => 38, "39個" => 39, "40個" => 40, "41個" => 41, "42個" => 42, "43個" => 43, "44個" => 44, "45個" => 45, "46個" => 46, "47個" => 47, "48個" => 48, "49個" => 49, "50個" => 50, "それ以上" => 999, "不明" => 1000 }
  
  # successful_egg_maturityの区分値(妊娠に至った卵子の成熟度)
  HUSH_SUCCESSFUL_EGG_MATURITY =  { "成熟卵(M2)" => 1, "未成熟卵(M1)" => 2, "未成熟卵(GV)" => 3, "不明" => 99 }

  # successful_embryo_culture_daysの区分値(妊娠に至った胚の培養日数)
  HUSH_SUCCESSFUL_EMBRYO_CULTURE_DAYS = { "1日" => 1, "2日" => 2, "3日" => 3, "4日" => 4, "5日" => 5, "6日" => 6, "7日" => 7, "8日" => 8, "9日" => 9, "10日" => 10, "それ以上" => 99, "不明" => 100 }

  # successful_embryo_grade_sizeの区分値(妊娠に至った胚の大きさ)
  HUSH_SUCCESSFUL_EMBRYO_GRADE_SIZE = { "1" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "その他" => 99, "不明" => 100 }
  
  # successful_embryo_grade_qualityの区分値(妊娠に至った胚の質)
  HUSH_SUCCESSFUL_EMBRYO_GRADE_QUALITY = { "AA" => 1, "AB" => 2, "AC" => 3, "BA" => 4, "BB" => 5, "BC" => 6, "CA" => 7, "CB" => 8, "CC" => 9, "その他" => 99, "不明" => 100 }
  # successful_embryo_gradeカラム名を上記のように変えてさらにsizeとqualityに分ける。IVMも検討？


  def str_fertility_treatment_number
    return HASH_FERTILITY_TREATMENT_NUMBER[self.fertility_treatment_number]
  end

  def str_treatment_type
    return HUSH_TREATMENT_TYPE[self.treatment_type]
  end

  # def current_state
  #   return HUSH_CURRENT_STATE[self.current_state]
  # end

  # def work_style
  #   return HUSH_WORK_STYLE[self.work_style]
  # end

  # def number_of_clinics
  #   return HUSH_NUMBER_OF_CLINICS[self.number_of_clinics]
  # end

  # def number_of_aih
  #   return HUSH_NUMBER_OF_AIH[self.number_of_aih]
  # end

  # def reatment_start_end_age
  #   return HUSH_TREATMENT_START_END_AGE[self.treatment_start_end_age]
  # end

  # def total_number_of_sairan_transplants
  #   return HUSH_TOTAL_NUMBER_OF_SAIRAN_TRANSPLANTS[self.total_number_of_sairan_transplants]
  # end

  # def number_of_eggs_collected
  #   return HUSH_NUMBER_OF_EGGS_COLLECTED[self.number_of_eggs_collected]
  # end

  # def type_of_sairan_cycle
  #   return HUSH_TYPE_OF_SAIRAN_CYCLE[self.type_of_sairan_cycle]
  # end

  # def types_of_fertilization_methods
  #   return HUSH_TYPES_OF_FERTILIZATION_METHODS[self.types_of_fertilization_methods]
  # end

  # def number_of_fertilized_frozen_stored_eggs
  #   return HUSH_NUMBER_OF_FERTILIZED_FROZEN_STORED_EGGS[self.number_of_fertilized_frozen_stored_eggs]
  # end

  # def successful_egg_maturity
  #   return HUSH_SUCCESSFUL_EGG_MATURITY[self.successful_egg_maturity]
  # end

  # def successful_embryo_culture_days
  #   return HUSH_SUCCESSFUL_EMBRYO_CULTURE_DAYS[self.successful_embryo_culture_days]
  # end

  # def successful_embryo_grade_size
  #   return HUSH_SUCCESSFUL_EMBRYO_GRADE_SIZE[self.successful_embryo_grade_size]
  # end

  # def successful_embryo_grade_quality
  #   return HUSH_SUCCESSFUL_EMBRYO_GRADE_QUALITY[self.successful_embryo_grade_quality]
  # end
end

# == Schema Information
#
# Table name: reports
#
#  id                             :bigint           not null, primary key
#  address_at_that_time           :integer
#  amh                            :integer
#  bmi                            :integer
#  content                        :text
#  current_state                  :integer
#  fertility_treatment_number     :integer
#  number_of_aih                  :integer
#  number_of_clinics              :integer
#  number_of_eggs_collected       :integer
#  number_of_eggs_stored          :integer
#  number_of_fertilized_eggs      :integer
#  number_of_frozen_eggs          :integer
#  successful_egg_maturity        :integer
#  successful_embryo_culture_days :integer
#  successful_embryo_grade        :integer
#  total_number_of_sairan         :integer
#  total_number_of_transplants    :integer
#  treatment_end_age              :integer
#  treatment_period               :integer
#  treatment_start_age            :integer
#  treatment_type                 :integer
#  type_of_sairan_cycle           :integer
#  types_of_eggs_and_sperm        :integer
#  types_of_fertilization_methods :integer
#  work_style                     :integer
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  latest_clinic_review_id        :integer
#  user_id                        :bigint           not null
#
# Indexes
#
#  index_reports_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
