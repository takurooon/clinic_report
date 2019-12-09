class Report < ApplicationRecord
  # バリデーション
  validates :title, length: { maximum: 32 }
  validate :validate_treatment_age
  validate :validate_content_length
  validate :validate_content_attachment_byte_size
  validate :validate_content_attachments_count
  
  
  def validate_treatment_age
    if treatment_start_age > treatment_end_age
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

  # like判定メソッド
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  # アクションテキスト
  has_rich_text :content
  
  # ---親---
    # ユーザー
  belongs_to :user
  belongs_to :clinic

  # ---子---
    # コメント
  has_many :comments, dependent: :destroy  
  has_many :likes, dependent: :destroy

  # ---多対多---
  has_many :report_clinics, dependent: :destroy
  has_many :clinics, through: :report_clinics

  # タグ
  has_many :report_tags, dependent: :destroy
  has_many :tags, through: :report_tags

  def save_reports(tag_list)
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
    old_tags = current_tags - tag_list
    new_tags = tag_list - current_tags

    # Destroy old taggings:
    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(tag_name: old_name)
    end

    # Create new taggings:
    new_tags.each do |new_name|
      report_tag = Tag.find_or_create_by(tag_name: new_name)
      self.tags << report_tag
    end
  end

  # サプリ
  has_many :report_supplements, dependent: :destroy
  has_many :supplements, through: :report_supplements
  accepts_nested_attributes_for :supplements
  
  # 不妊原因(男女それぞれ)
  has_many :report_f_infertility_factors, dependent: :destroy
  has_many :f_infertility_factors, through: :report_f_infertility_factors
  accepts_nested_attributes_for :f_infertility_factors
  has_many :report_m_infertility_factors, dependent: :destroy
  has_many :m_infertility_factors, through: :report_m_infertility_factors
  accepts_nested_attributes_for :m_infertility_factors

  # 疾患(男女それぞれ)
  has_many :report_f_diseases, dependent: :destroy
  has_many :f_diseases, through: :report_f_diseases
  accepts_nested_attributes_for :f_diseases
  has_many :report_m_diseases, dependent: :destroy
  has_many :m_diseases, through: :report_m_diseases
  accepts_nested_attributes_for :m_diseases

  # 手術歴(男女それぞれ)
  has_many :report_f_surgeries, dependent: :destroy
  has_many :f_surgeries, through: :report_f_surgeries
  accepts_nested_attributes_for :f_surgeries
  has_many :report_m_surgeries, dependent: :destroy
  has_many :m_surgeries, through: :report_m_surgeries
  accepts_nested_attributes_for :m_surgeries

  # 卵巣刺激薬剤
  has_many :report_ovarian_stimulations, dependent: :destroy
  has_many :ovarian_stimulations, through: :report_ovarian_stimulations
  accepts_nested_attributes_for :ovarian_stimulations

  # 排卵抑制剤
  has_many :report_ovulation_inhibitors, dependent: :destroy
  has_many :ovulation_inhibitors, through: :report_ovulation_inhibitors
  accepts_nested_attributes_for :ovulation_inhibitors

  # 排卵促進剤
  has_many :report_ovulation_inducers, dependent: :destroy
  has_many :ovulation_inducers, through: :report_ovulation_inducers
  accepts_nested_attributes_for :ovulation_inducers

  # 移植オプション
  has_many :report_transfer_options, dependent: :destroy
  has_many :transfer_options, through: :report_transfer_options
  accepts_nested_attributes_for :transfer_options

  # 治療の開示範囲
  has_many :report_scope_of_disclosures, dependent: :destroy
  has_many :scope_of_disclosures, through: :report_scope_of_disclosures
  accepts_nested_attributes_for :scope_of_disclosures

  # クリニックでの治療以外で行ったこと(努力)
  has_many :report_other_efforts, dependent: :destroy
  has_many :other_efforts, through: :report_other_efforts
  accepts_nested_attributes_for :scope_of_disclosures


  # treatment_typeの区分値(治療方法)
  HASH_TREATMENT_TYPE = {
    1 => "高度不妊治療(体外/顕微受精)",
    2 => "人工授精",
    3 => "タイミング指導法",
    99 => "その他"
  }

  def str_treatment_type
    return HASH_TREATMENT_TYPE[self.treatment_type]
  end


  # current_stateの区分値(現在の状況)
  HASH_CURRENT_STATE = {
    1 => "現在妊娠中",
    2 => "出産した",
    3 => "妊娠または出産に至らず転院(治療継続予定)",
    4 => "不妊治療を辞めた(治療自体を継続しない)"
  }

  def str_current_state
    return HASH_CURRENT_STATE[self.current_state]
  end

  
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

  def str_treatment_period
    return HASH_TREATMENT_PERIOD[self.treatment_period]
  end


  # bmiの区分値(BMI値)
  HASH_BMI = {
    1 => "18.5未満",
    2 => "18.5〜25未満",
    3 => "25〜30未満",
    4 => "30〜35未満",
    5 => "35〜40未満",
    6 => "40以上"
  }

  def str_bmi
    return HASH_BMI[self.bmi]
  end
  

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

  def str_amh
    return HASH_AMH[self.amh]
  end

  
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

  def str_types_of_eggs_and_sperm
    return HASH_TYPES_OF_EGGS_AND_SPERM[self.types_of_eggs_and_sperm]
  end


  # type_of_sairan_cycleの区分値(採卵周期種別)
  HASH_TYPE_OF_SAIRAN_CYCLE = {
    1 => "完全自然周期",
    2 => "クロミフェン(クロミッド)法",
    3 => "hMG/rFSH法",
    4 => "クロミフェン+hMG/rFSH法",
    5 => "ロング法",
    6 => "ショート法",
    7 => "アンタゴニスト法",
    99 => "その他",
    100 => "不明"
  }

  def str_type_of_sairan_cycle
    return HASH_TYPE_OF_SAIRAN_CYCLE[self.type_of_sairan_cycle]
  end


  # types_of_fertilization_methodsの区分値(受精方法)
  HASH_TYPES_OF_FERTILIZATION_METHODS = {
    1 => "体外受精（ふりかけ）",
    2 => "顕微授精",
    3 => "スプリット法",
    100 => "不明"
  }

  def str_types_of_fertilization_methods
    return HASH_TYPES_OF_FERTILIZATION_METHODS[self.types_of_fertilization_methods]
  end


  # egg_maturityの区分値(妊娠に至った卵子の成熟度)
  HASH_EGG_MATURITY =  {
    1 => "成熟卵(M2)",
    2 => "未成熟卵(M1)",
    3 => "未成熟卵(GV)",
    99 => "その他",
    100 => "不明"
  }

  def str_egg_maturity
    return HASH_EGG_MATURITY[self.egg_maturity]
  end

  
  # embryo_stageの区分値(妊娠に至った胚のステージ)
  HASH_EMBRYO_STAGE = {
    1 => "初期胚",
    2 => "胚盤胞以上",
    99 => "その他",
    100 => "不明"
  }

  def str_embryo_stage
    return HASH_EMBRYO_STAGE[self.embryo_stage]
  end


  # early_embryo_gradeの区分値(初期胚のグレード)
  HASH_EARLY_EMBRYO_GRADE = {
    1 => "グレード1",
    2 => "グレード2",
    3 => "グレード3",
    4 => "グレード4",
    5 => "グレード5",
    9 => "その他",
    100 => "不明"
  }

  def str_early_embryo_grade
    return HASH_EARLY_EMBRYO_GRADE[self.early_embryo_grade]
  end


  # blastocyst_grade1の区分値(胚盤胞以上のグレード)
  HASH_BLASTOCYST_GRADE1 = {
    1 => "1 (初期胚盤胞)",
    2 => "2 (胚盤胞)",
    3 => "3 (完全胚盤胞)",
    4 => "4 (拡張胚盤胞)",
    5 => "5 (孵化胚盤胞)",
    6 => "6 (孵化後胚盤胞)",
    99 => "その他",
    100 => "不明"
  }

  def str_blastocyst_grade1
    return HASH_BLASTOCYST_GRADE1[self.blastocyst_grade1]
  end


  # blastocyst_grade2の区分値(胚盤胞以上の評価/ICM/TE)
  HASH_BLASTOCYST_GRADE2 = {
    1 => "AA",
    2 => "AB",
    3 => "AC",
    4 => "BA",
    5 => "BB",
    6 => "BC",
    7 => "CA",
    8 => "CB",
    9 => "CC",
    10 => "A不明",
    11 => "B不明",
    12 => "C不明",
    13 => "不明A",
    14 => "不明B",
    15 => "不明C",
    99 => "その他",
    100 => "不明"
  }

  def str_blastocyst_grade2
    return HASH_BLASTOCYST_GRADE2[self.blastocyst_grade2]
  end


  # ova_with_ivmの区分値(妊娠に至った卵子へのIVMの有無)
  HASH_OVA_WITH_IVM = {
    1 => "あり",
    2 => "なし",
    100 => "不明"
  }

  def str_ova_with_ivm
    return HASH_OVA_WITH_IVM[self.ova_with_ivm]
  end


  # costの区分値(CLでの費用総額)
  HASH_COST = {
    1 => "10万円未満",
    2 => "20万円未満",
    3 => "30万円未満",
    4 => "40万円未満",
    5 => "50万円未満",
    6 => "60万円未満",
    7 => "70万円未満",
    8 => "80万円未満",
    9 => "90万円未満",
    10 => "100万円未満",
    11 => "110万円未満",
    12 => "120万円未満",
    13 => "130万円未満",
    14 => "140万円未満",
    15 => "150万円未満",
    16 => "160万円未満",
    17 => "170万円未満",
    18 => "180万円未満",
    19 => "190万円未満",
    20 => "200万円未満",
    21 => "210万円未満",
    22 => "950〜1,000万円未満",
    23 => "1,000〜1,500万円未満",
    24 => "1,500〜2,000万円未満",
    99 => "2,000万円以上",
    100 => "不明"
  }

  def str_cost
    return HASH_COST[self.cost]
  end


  # credit_card_validityの区分値(クレジットカード使用可否)
  HASH_CREDIT_CARD_VALIDITY = {
    1 => "可",
    2 => "不可",
    3 => "一定の金額から使用可能",
    99 => "その他",
    100 => "不明"
    }

  def str_credit_card_validity
    return HASH_CREDIT_CARD_VALIDITY[self.credit_card_validity]
  end
  

  # average_waiting_timeの区分値(クリニックでの平均待ち時間)
  HASH_AVERAGE_WAITING_TIME = {
    1 => "〜1時間",
    2 => "〜2時間",
    3 => "〜3時間",
    4 => "〜4時間",
    5 => "〜5時間",
    99 => "それ以上",
    100 => "不明"
  }

  def str_average_waiting_time
    return HASH_AVERAGE_WAITING_TIME[self.average_waiting_time]
  end


  # clinic_selection_criteriaの区分値(このクリニック選定理由)
  HASH_CLINIC_SELECTION_CRITERIA = {
    1 => "自宅から近かったから",
    2 => "職場から近かったから",
    3 => "口コミがよかったから",
    4 => "料金が手頃だったから",
    5 => "以前に通ったことがあったから",
    6 => "知人から勧められたから",
    99 => "その他"
    }

  def str_clinic_selection_criteria
    return HASH_CLINIC_SELECTION_CRITERIA[self.clinic_selection_criteria]
  end


  # industry_typeの区分値(業種) ※参考→業種コード表（日本標準産業分類）
  HASH_INDUSTRY_TYPE = {
    1 => "農業 林業",
    2 => "漁業",
    3 => "鉱業 採石業 砂利採取業",
    4 => "建設業",
    5 => "製造業",
    6 => "電気 ガス 熱供給 水道業",
    7 => "情報通信業",
    8 => "運輸業 郵便業",
    9 => "卸売業 小売業",
    10 => "金融業 保険業",
    11 => "不動産業 物品賃貸業",
    12 => "学術研究 専門サービス業",
    13 => "生活関連サービス業 娯楽業",
    14 => "教育 学習支援業",
    15 => "医療 福祉",
    16 => "複合サービス事業",
    17 => "サービス業(他に分類されないもの)",
    18 => "公務員",
    19 => "分類不能の産業"
  }

  def str_industry_type
    return HASH_INDUSTRY_TYPE[self.industry_type]
  end


  # private_or_listed_companyの区分値(上場非上場)
  HASH_PRIVATE_OR_LISTED_COMPANY = {
    1 => "上場企業",
    2 => "非上場企業",
    100 => "不明"
  }

  def str_private_or_listed_company
    return HASH_PRIVATE_OR_LISTED_COMPANY[self.private_or_listed_company]
  end


  # domestic_or_foreign_capitalの区分値(日系or外資)
  HASH_DOMESTIC_OR_FOREIGN_CAPITAL = {
    1 => "日系企業",
    2 => "外資系企業",
    99 => "その他",
    100 => "不明"
  }

  def str_domestic_or_foreign_capital
    return HASH_DOMESTIC_OR_FOREIGN_CAPITAL[self.domestic_or_foreign_capital]
  end


  # capital_sizeの区分値(資本金)
  HASH_CAPITAL_SIZE = {
    1 => "5千万円以下",
    2 => "1億円以下",
    3 => "3億円以下",
    4 => "3億円よりも大きい",
    100 => "不明"
  }

  def str_capital_size
    return HASH_CAPITAL_SIZE[self.capital_size]
  end


  # departmentの区分値(部署)
  HASH_DEPARTMENT = {
    1 => "企画･広報",
    2 => "販売･営業",
    3 => "製造･生産",
    4 => "調達･購買",
    5 => "生産管理･品質管理",
    6 => "技術･研究開発",
    7 => "総務･人事",
    8 => "経理･財務",
    9 => "情報システム",
    99 => "その他",
    100 => "不明"
  }

  def str_department
    return HASH_DEPARTMENT[self.department]
  end  


  # positionの区分値(役職)
  HASH_POSITION = {
    1 => "経営層･役員クラス",
    2 => "部長クラス",
    3 => "課長クラス",
    4 => "係長･主任クラス",
    5 => "一般社員クラス",
    6 => "その他専門職･特別職等",
    99 => "その他"
  }

  def str_position
    return HASH_POSITION[self.position]
  end


  # number_of_employeesの区分値(従業員数)
  HASH_NUMBER_OF_EMPLOYEES = {
    1 => "5人以下",
    2 => "20人以下",
    3 => "50人以下",
    4 => "100人以下",
    5 => "500人以下",
    6 => "千人以下",
    7 => "5千人以下",
    8 => "1万人以下",
    99 => "それ以上",
    100 => "不明"
  }

  def str_number_of_employees
    return HASH_NUMBER_OF_EMPLOYEES[self.number_of_employees]
  end


  # work_styleの区分値(働き方)
  HASH_WORK_STYLE = {
    1 => "公務員",
    2 => "会社役員",
    3 => "会社員(正社員)",
    4 => "会社員(契約社員/派遣社員)",
    5 => "自営業/フリーランス",
    6 => "パート/アルバイト",
    7 => "学生",
    8 => "主婦",
    9 => "無職",
    99 => "その他"
  }

  def str_work_style
    return HASH_WORK_STYLE[self.work_style]
  end


  # suspended_or_retirement_jobの区分値(治療に際しての働き方の変化)
  HASH_SUSPENDED_OR_RETIREMENT_JOB = {
    1 => "特に変わっていない",
    2 => "休職した",
    3 => "退職した",
    4 => "転職した",
    5 => "異動した(転部)",
    6 => "役職を変えた",
    99 => "その他"
  }

  def str_suspended_or_retirement_job
    return HASH_SUSPENDED_OR_RETIREMENT_JOB[self.suspended_or_retirement_job]
  end


  # treatment_support_systemの区分値(社内の不妊治療のサポート制度有無)
  HASH_TREATMENT_SUPPORT_SYSTEM = {
    1 => "有る",
    2 => "無い",
    3 => "有るが機能していない(形骸化)",
    4 => "制度導入予定",
    99 => "その他",
    100 => "不明"
  }

  def str_treatment_support_system
    return HASH_TREATMENT_SUPPORT_SYSTEM[self.treatment_support_system]
  end


  # smokingの区分値(喫煙有無)
  HASH_SMOKING = {
    1 => "もとから非喫煙者(断煙済み)",
    2 => "治療のために禁煙した",
    3 => "禁煙しなかった",
    99 => "その他"
  }

  def str_smoking
    return HASH_SMOKING[self.smoking]
  end

  # average_waiting_timeの区分値(クリニックでの平均待ち時間)
  HASH_AVERAGE_WAITING_TIME = {
    1 => "1時間以内",
    2 => "2時間以内",
    3 => "3時間以内",
    4 => "4時間以内",
    5 => "5時間以内",
    99 => "それ以上"
  }

  def str_average_waiting_time
    return HASH_AVERAGE_WAITING_TIME[self.average_waiting_time]
  end


  # address_at_that_timeの区分値(治療中の住まい)


  # period_of_time_spent_travelingの区分値(通院時間)
  HASH_PERIOD_OF_TIME_SPENT_TRAVELING = {
    1 => "1時間以内",
    2 => "2時間以内",
    3 => "3時間以内",
    4 => "4時間以内",
    5 => "5時間以内",
    99 => "それ以上"
  }

  def str_period_of_time_spent_traveling
    return HASH_PERIOD_OF_TIME_SPENT_TRAVELING[self.period_of_time_spent_traveling]
  end




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
  LESS_YEN = "円未満"
  
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

  # all_number_of_sairanの区分値(全採卵回数/CL単位)
  ALL_NUMBER_OF_SAIRAN_MAXIMUM = 1000
  ALL_NUMBER_OF_SAIRAN_RANGE = 20
  UPPER_THE_ALL_NUMBER_OF_SAIRAN_RANGE = ALL_NUMBER_OF_SAIRAN_RANGE + 1
  STR_ALL_NUMBER_OF_SAIRAN_MAXIMUM = "#{UPPER_THE_ALL_NUMBER_OF_SAIRAN_RANGE}#{TIMES}#{OR_MORE}"

  def str_all_number_of_sairan
    if self.all_number_of_sairan == ALL_NUMBER_OF_SAIRAN_MAXIMUM
      STR_ALL_NUMBER_OF_SAIRAN_MAXIMUM
    elsif self.all_number_of_sairan >= 1 || self.all_number_of_sairan <= ALL_NUMBER_OF_SAIRAN_RANGE
      "#{self.all_number_of_sairan} #{TIMES}"
    else
      raise
    end
  end

  def self.make_select_options_all_number_of_sairan
    hash = {}
    (1..ALL_NUMBER_OF_SAIRAN_RANGE).each do |i|
      hash["#{i}#{TIMES}"] = i
    end

    hash[STR_ALL_NUMBER_OF_SAIRAN_MAXIMUM] = STR_ALL_NUMBER_OF_SAIRAN_MAXIMUM
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

  # all_number_of_transplantsの区分値(全移植回数/CL単位)
  ALL_NUMBER_OF_TRANSPLANTS_MAXIMUM = 1000
  ALL_NUMBER_OF_TRANSPLANTS_RANGE = 20
  UPPER_THE_ALL_NUMBER_OF_TRANSPLANTS_RANGE = ALL_NUMBER_OF_TRANSPLANTS_RANGE + 1
  STR_ALL_NUMBER_OF_TRANSPLANTS_MAXIMUM = "#{UPPER_THE_ALL_NUMBER_OF_TRANSPLANTS_RANGE}#{TIMES}#{OR_MORE}"

  def str_all_number_of_transplants
    if self.all_number_of_transplants == ALL_NUMBER_OF_TRANSPLANTS_MAXIMUM
      STR_ALL_NUMBER_OF_TRANSPLANTS_MAXIMUM
    elsif self.all_number_of_transplants >= 1 || self.all_number_of_transplants <= ALL_NUMBER_OF_TRANSPLANTS_RANGE
      "#{self.all_number_of_transplants} #{TIMES}"
    else
      raise
    end
  end

  def self.make_select_options_all_number_of_transplants
    hash = {}
    (1..ALL_NUMBER_OF_TRANSPLANTS_RANGE).each do |i|
      hash["#{i}#{TIMES}"] = i
    end
    hash[STR_ALL_NUMBER_OF_TRANSPLANTS_MAXIMUM] = STR_ALL_NUMBER_OF_TRANSPLANTS_MAXIMUM
    hash
  end

  # number_of_eggs_collectedの区分値(採卵個数/CL単位)
  NUMBER_OF_EGGS_COLLECTED_MAXIMUM = 1000
  NUMBER_OF_EGGS_COLLECTED_RANGE1 = 100
  NUMBER_OF_EGGS_COLLECTED_RANGE2 = 106
  STR_NUMBER_OF_EGGS_COLLECTED_MAXIMUM = "1,000#{PIECES}#{OR_MORE}"

  def str_number_of_eggs_collected
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

  # embryo_culture_daysの区分値(妊娠に至った胚の培養日数)
  EMBRYO_CULTURE_DAYS_MAXIMUM = 1000
  EMBRYO_CULTURE_DAYS_RANGE = 10
  STR_EMBRYO_CULTURE_DAYS_MAXIMUM = "それ#{DAY}#{OR_MORE}"

  def str_embryo_culture_days
    case self.embryo_culture_days
    when UNKNOWN
      STR_UNKNOWN
    when EMBRYO_CULTURE_DAYS_MAXIMUM
      STR_EMBRYO_CULTURE_DAYS_MAXIMUM
    when 1..EMBRYO_CULTURE_DAYS_RANGE
      "#{self.embryo_culture_days} #{DAY}"
    else
      raise
    end
  end

  def self.make_select_options_embryo_culture_days
    hash = {}
    (1..EMBRYO_CULTURE_DAYS_RANGE).each do |i|
      hash["#{i}#{DAY}"] = i
    end
    hash[STR_EMBRYO_CULTURE_DAYS_MAXIMUM] = STR_EMBRYO_CULTURE_DAYS_MAXIMUM
    hash[STR_UNKNOWN] = STR_UNKNOWN
    hash
  end

  # embryo_grade_sizeの区分値(妊娠に至った胚の大きさ) ないsize
  HASH_EMBRYO_GRADE_SIZE = { "1" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "その他" => 99, "不明" => 100 }
  EMBRYO_GRADE_SIZE_MAXIMUM = 1000
  EMBRYO_GRADE_SIZE_RANGE = 10
  STR_EMBRYO_GRADE_SIZE_MAXIMUM = "それ#{DAY}#{OR_MORE}"

  def str_embryo_grade_size
    case self.embryo_grade_size
    when UNKNOWN
      STR_UNKNOWN
    when EMBRYO_GRADE_SIZE_MAXIMUM
      STR_EMBRYO_GRADE_SIZE_MAXIMUM
    when 1..EMBRYO_GRADE_SIZE_RANGE1
      "#{self.embryo_grade_size} #{DAY}"
    else
      raise
    end
  end

  def self.make_select_options_embryo_grade_size
    hash = {}
    (1..EMBRYO_GRADE_SIZE_RANGE).each do |i|
      hash["#{i}#{DAY}"] = i
    end
    hash[STR_EMBRYO_GRADE_SIZE_MAXIMUM] = STR_EMBRYO_GRADE_SIZE_MAXIMUM
    hash[STR_UNKNOWN] = STR_UNKNOWN
    hash
  end
end

# == Schema Information
#
# Table name: reports
#
#  id                               :bigint           not null, primary key
#  address_at_that_time             :integer
#  all_number_of_sairan             :integer
#  all_number_of_transplants        :integer
#  amh                              :integer
#  average_waiting_time             :integer
#  blastocyst_grade1                :integer
#  blastocyst_grade2                :integer
#  bmi                              :integer
#  capital_size                     :integer
#  clinic_review                    :text
#  clinic_selection_criteria        :integer
#  content                          :text
#  cost                             :integer
#  credit_card_validity             :integer
#  current_state                    :integer
#  department                       :integer
#  domestic_or_foreign_capital      :integer
#  early_embryo_grade               :integer
#  egg_maturity                     :integer
#  embryo_culture_days              :integer
#  embryo_stage                     :integer
#  fertility_treatment_number       :integer
#  industry_type                    :integer
#  number_of_aih                    :integer
#  number_of_clinics                :integer
#  number_of_eggs_collected         :integer
#  number_of_eggs_stored            :integer
#  number_of_employees              :integer
#  number_of_fertilized_eggs        :integer
#  number_of_frozen_eggs            :integer
#  ova_with_ivm                     :integer
#  period_of_time_spent_traveling   :integer
#  position                         :integer
#  private_or_listed_company        :integer
#  reasons_for_choosing_this_clinic :text
#  smoking                          :integer
#  suspended_or_retirement_job      :integer
#  title                            :string
#  total_number_of_sairan           :integer
#  total_number_of_transplants      :integer
#  treatment_end_age                :integer
#  treatment_period                 :integer
#  treatment_start_age              :integer
#  treatment_support_system         :integer
#  treatment_type                   :integer
#  type_of_sairan_cycle             :integer
#  types_of_eggs_and_sperm          :integer
#  types_of_fertilization_methods   :integer
#  work_style                       :integer
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  clinic_id                        :bigint           not null
#  user_id                          :bigint           not null
#
# Indexes
#
#  index_reports_on_clinic_id  (clinic_id)
#  index_reports_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (clinic_id => clinics.id)
#  fk_rails_...  (user_id => users.id)
#
