class Report < ApplicationRecord

  # レポートの公開状況 参考:https://qiita.com/tomoharutt/items/f1a70babaddcf7ab47be
  enum status: { released: 0, nonreleased: 1 }

  # 年収/世帯合算所得の公開状況 参考:https://qiita.com/emacs_hhkb/items/fce19f443e5770ad2e13
  enum annual_income_status: { show: 0, hide: 1 }, _prefix: true
  enum household_net_income_status: { show: 0, hide: 1 }, _prefix: true

  # 治療当時の住まいの公開状況 参考:http://mnmandahalf.hatenablog.com/entry/2017/08/20/164442
  enum prefecture_at_the_time_status: { show: 0, hide: 1 }, _prefix: true
  enum city_at_the_time_status: { show: 0, hide: 1 }, _prefix: true

  # バリデーション
  validates :title, length: { maximum: 32 }
  validate :validate_treatment_age
  validate :validate_all_treatment_age
  validate :validate_all_number_of_sairan
  validate :validate_all_number_of_transplants
  validate :validate_content_length
  validate :validate_content_attachment_byte_size
  validate :validate_content_attachments_count
  # validate :validate_content_report_count

  MAX_CONTENT_LENGTH = 30000
  MEGA_BYTES = 3
  ONE_KILOBYTE = 1024
  MAX_CONTENT_ATTACHMENT_BYTE_SIZE = MEGA_BYTES * 1_000 * ONE_KILOBYTE
  MAX_CONTENT_ATTACHMENTS_COUNT = 4

  def validate_treatment_age
    return "" if self.treatment_start_age.nil?
    return "" if self.treatment_end_age.nil?
    if treatment_start_age > treatment_end_age
      errors.add(
        :base,
        :treatment_end_age_is_earlier_than_treatment_start_age
      )
    end
  end

  def validate_all_treatment_age
    return "" if self.first_age_to_start.nil?
    return "" if self.treatment_start_age.nil?
    if first_age_to_start > treatment_start_age
      errors.add(
        :base,
        :cl_treatment_start_age_is_earlier_than_first_start_age
      )
    end
  end

  def validate_all_number_of_sairan
    return "" if self.total_number_of_sairan.nil?
    return "" if self.all_number_of_sairan.nil?
    if total_number_of_sairan > all_number_of_sairan
      errors.add(
        :base,
        :the_number_of_sairan_at_this_clinic_exceeds_the_cumulative_total
      )
    end
  end

  def validate_all_number_of_transplants
    return "" if self.total_number_of_transplants.nil?
    return "" if self.all_number_of_transplants.nil?
    if total_number_of_transplants > all_number_of_transplants
      errors.add(
        :base,
        :number_of_transplants_at_this_clinic_exceeds_cumulative_total
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

  # def validate_content_report_count
  #   if user.reports.count > 1
  #     errors.add(
  #       :base, 
  #       :only_one_report_is_allowed
  #     )
  #   end
  # end

  def normalize
    if self.embryo_stage == 1
      self.blastocyst_grade1 = nil
      self.blastocyst_grade2 = nil
      self.haibanhoishoku_hormones = []
    elsif self.embryo_stage == 2
      self.early_embryo_grade = nil
      self.shokihaiishoku_hormones = []
    else
      self.early_embryo_grade = nil
      self.blastocyst_grade1 = nil
      self.blastocyst_grade2 = nil
      self.shokihaiishoku_hormones = []
      self.haibanhoishoku_hormones = []
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
  belongs_to :prefecture, optional: true
  belongs_to :city, optional: true

  # ---子---
    # 転院遍歴
    has_many :itinerary_of_choosing_a_clinics, dependent: :destroy
    accepts_nested_attributes_for :itinerary_of_choosing_a_clinics, allow_destroy: true, update_only: true

    # コメント
    has_many :comments, dependent: :destroy
    has_many :likes, dependent: :destroy

    # 採卵時のホルモン
    has_many :sairan_hormones, inverse_of: :report, dependent: :destroy
    accepts_nested_attributes_for :sairan_hormones, allow_destroy: true, update_only: true

    # 初期胚移植のホルモン
    has_many :shokihaiishoku_hormones, inverse_of: :report, dependent: :destroy
    accepts_nested_attributes_for :shokihaiishoku_hormones, allow_destroy: true, update_only: true

    # 胚盤胞移植のホルモン
    has_many :haibanhoishoku_hormones, inverse_of: :report, dependent: :destroy
    accepts_nested_attributes_for :haibanhoishoku_hormones, allow_destroy: true, update_only: true

  # 検索
  def self.search(search)
    if search
      where(['name LIKE ?', "%#{search}%"])
    else
      all
    end
  end

  # 検査項目
  has_many :report_inspections, dependent: :destroy
  has_many :inspections, through: :report_inspections

  # def save_i(i_list)
  #   current_is = self.inspections.pluck(:name) unless self.inspections.nil?
  #   old_is = current_is - i_list
  #   new_is = i_list - current_is

    # Destroy old inspections:
    # old_is.each do |old_name|
    #   self.inspections.delete Tag.find_by(name: old_name)
    # end

    # Create new inspections:
  #   new_is.each do |new_name|
  #     report_i = Inspection.find_or_create_by(name: new_name)
  #     self.inspections << report_i
  #   end
  # end
  
  # 不妊原因(男女それぞれ)
  has_many :report_f_infertility_factors, dependent: :destroy
  has_many :f_infertility_factors, through: :report_f_infertility_factors
  accepts_nested_attributes_for :f_infertility_factors
  has_many :report_m_infertility_factors, dependent: :destroy
  has_many :m_infertility_factors, through: :report_m_infertility_factors
  accepts_nested_attributes_for :m_infertility_factors

  def save_fifs(fif_list)
    current_fifs = self.f_infertility_factors.pluck(:name) unless self.f_infertility_factors.nil?
    old_fifs = current_fifs - fif_list
    new_fifs = fif_list - current_fifs

    # Destroy old f_infertility_factors:
    old_fifs.each do |old_name|
      self.f_infertility_factors.delete FInfertilityFactor.find_by(name: old_name)
    end

    # Create new f_infertility_factors:
    new_fifs.each do |new_name|
      report_fif = FInfertilityFactor.find_or_create_by(name: new_name)
      self.f_infertility_factors << report_fif
    end
  end

  def save_mifs(mif_list)
    current_mifs = self.m_infertility_factors.pluck(:name) unless self.m_infertility_factors.nil?
    old_mifs = current_mifs - mif_list
    new_mifs = mif_list - current_mifs

    # Destroy old mim_infertility_factorsfs:
    old_mifs.each do |old_name|
      self.m_infertility_factors.delete MInfertilityMactor.find_by(name: old_name)
    end

    # Create new m_infertility_factors:
    new_mifs.each do |new_name|
      report_mif = MInfertilityFactor.find_or_create_by(name: new_name)
      self.m_infertility_factors << report_mif
    end
  end

  # 疾患(男女それぞれ)
  has_many :report_f_diseases, dependent: :destroy
  has_many :f_diseases, through: :report_f_diseases
  accepts_nested_attributes_for :f_diseases
  has_many :report_m_diseases, dependent: :destroy
  has_many :m_diseases, through: :report_m_diseases
  accepts_nested_attributes_for :m_diseases

  def save_fds(fd_list)
    current_fds = self.f_diseases.pluck(:name) unless self.f_diseases.nil?
    old_fds = current_fds - fd_list
    new_fds = fd_list - current_fds

    # Destroy old f_diseases:
    old_fds.each do |old_name|
      self.f_diseases.delete FDisease.find_by(name: old_name)
    end

    # Create new f_diseases:
    new_fds.each do |new_name|
      report_fd = FDisease.find_or_create_by(name: new_name)
      self.f_diseases << report_fd
    end
  end

  def save_mds(md_list)
    current_mds = self.m_diseases.pluck(:name) unless self.m_diseases.nil?
    old_mds = current_mds - md_list
    new_mds = md_list - current_mds

    # Destroy old m_diseases:
    old_mds.each do |old_name|
      self.m_diseases.delete MDisease.find_by(name: old_name)
    end

    # Create new m_diseases:
    new_mds.each do |new_name|
      report_md = MDisease.find_or_create_by(name: new_name)
      self.m_diseases << report_md
    end
  end

  # 手術歴(男女それぞれ)
  has_many :report_f_surgeries, dependent: :destroy
  has_many :f_surgeries, through: :report_f_surgeries
  accepts_nested_attributes_for :f_surgeries
  has_many :report_m_surgeries, dependent: :destroy
  has_many :m_surgeries, through: :report_m_surgeries
  accepts_nested_attributes_for :m_surgeries

  def save_fss(fs_list)
    current_fss = self.f_surgeries.pluck(:name) unless self.f_surgeries.nil?
    old_fss = current_fss - fs_list
    new_fss = fs_list - current_fss

    # Destroy old f_surgeries:
    old_fss.each do |old_name|
      self.f_surgeries.delete FSurgery.find_by(name: old_name)
    end

    # Create new f_surgeries:
    new_fss.each do |new_name|
      report_fs = FSurgery.find_or_create_by(name: new_name)
      self.f_surgeries << report_fs
    end
  end

  def save_mss(ms_list)
    current_mss = self.m_surgeries.pluck(:name) unless self.m_surgeries.nil?
    old_mss = current_mss - ms_list
    new_mss = ms_list - current_mss

    # Destroy old m_surgeries:
    old_mss.each do |old_name|
      self.m_surgeries.delete MSurgery.find_by(name: old_name)
    end

    # Create new m_surgeries:
    new_mss.each do |new_name|
      report_ms = MSurgery.find_or_create_by(name: new_name)
      self.m_surgeries << report_ms
    end
  end

  # 採卵周期での使用薬剤
  has_many :report_sairan_medicines, dependent: :destroy
  has_many :sairan_medicines, through: :report_sairan_medicines
  accepts_nested_attributes_for :sairan_medicines

  def save_sms(sm_list)
    current_sms = self.sairan_medicines.pluck(:name) unless self.sairan_medicines.nil?
    old_sms = current_sms - sm_list
    new_sms = sm_list - current_sms

    # Destroy old sairan_medicines:
    old_sms.each do |old_name|
      self.sairan_medicines.delete SairanMedicine.find_by(name: old_name)
    end

    # Create new sairan_medicines:
    new_sms.each do |new_name|
      report_sm = SairanMedicine.find_or_create_by(name: new_name)
      self.sairan_medicines << report_sm
    end
  end

  # 移植周期での使用薬剤
  has_many :report_transfer_medicines, dependent: :destroy
  has_many :transfer_medicines, through: :report_transfer_medicines
  accepts_nested_attributes_for :transfer_medicines

  def save_tms(tm_list)
    current_tms = self.transfer_medicines.pluck(:name) unless self.transfer_medicines.nil?
    old_tms = current_tms - tm_list
    new_tms = tm_list - current_tms

    # Destroy old transfer_medicines:
    old_tms.each do |old_name|
      self.tms.delete TransferMedicine.find_by(name: old_name)
    end

    # Create new transfer_medicines:
    new_tms.each do |new_name|
      report_tm = TransferMedicine.find_or_create_by(name: new_name)
      self.transfer_medicines << report_tm
    end
  end

  # 移植オプション
  has_many :report_transfer_options, dependent: :destroy
  has_many :transfer_options, through: :report_transfer_options
  accepts_nested_attributes_for :transfer_options

  def save_tos(to_list)
    current_tos = self.transfer_options.pluck(:name) unless self.transfer_options.nil?
    old_tos = current_tos - to_list
    new_tos = to_list - current_tos

    # Destroy old transfer_options:
    old_tos.each do |old_name|
      self.tos.delete TransferOption.find_by(name: old_name)
    end

    # Create new transfer_options:
    new_tos.each do |new_name|
      report_to = TransferOption.find_or_create_by(name: new_name)
      self.transfer_options << report_to
    end
  end

  # クリニックでの治療以外で行ったこと(努力)
  has_many :report_other_efforts, dependent: :destroy
  has_many :other_efforts, through: :report_other_efforts
  accepts_nested_attributes_for :other_efforts

  def save_oes(oe_list)
    current_oes = self.other_efforts.pluck(:name) unless self.other_efforts.nil?
    old_oes = current_oes - oe_list
    new_oes = oe_list - current_oes

    # Destroy old other_efforts:
    old_oes.each do |old_name|
      self.oes.delete OtherEffort.find_by(name: old_name)
    end

    # Create new other_efforts:
    new_oes.each do |new_name|
      report_oe = OtherEffort.find_or_create_by(name: new_name)
      self.other_efforts << report_oe
    end
  end

  # サプリ
  has_many :report_supplements, dependent: :destroy
  has_many :supplements, through: :report_supplements
  accepts_nested_attributes_for :supplements

  def save_supplements(supplement_list)
    current_supplements = self.supplements.pluck(:name) unless self.supplements.nil?
    old_supplements = current_supplements - supplement_list
    new_supplements = supplement_list - current_supplements

    # Destroy old supplements:
    old_supplements.each do |old_name|
      self.supplements.delete Supplement.find_by(name: old_name)
    end

    # Create new supplements:
    new_supplements.each do |new_name|
      report_supplement = Supplement.find_or_create_by(name: new_name)
      self.supplements << report_supplement
    end
  end

  # 治療の開示範囲
  has_many :report_scope_of_disclosures, dependent: :destroy
  has_many :scope_of_disclosures, through: :report_scope_of_disclosures
  accepts_nested_attributes_for :scope_of_disclosures

  def save_sods(sod_list)
    current_sods = self.scope_of_disclosures.pluck(:scope) unless self.scope_of_disclosures.nil?
    old_sods = current_sods - sod_list
    new_sods = sod_list - current_sods

    # Destroy old scope_of_disclosures:
    old_sods.each do |old_scope|
      self.scope_of_disclosures.delete ScopeOfDisclosure.find_by(scope: old_scope)
    end

    # Create new scope_of_disclosures:
    new_sods.each do |new_scope|
      report_sod = ScopeOfDisclosure.find_or_create_by(scope: new_scope)
      self.scope_of_disclosures << report_sod
    end
  end

  # タグ
  has_many :report_tags, dependent: :destroy
  has_many :tags, through: :report_tags

  def save_tags(tag_list)
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

  # treatment_typeの区分値(治療方法)
  HASH_TREATMENT_TYPE = {
    1 => "体外受精または顕微授精",
    2 => "人工授精",
    99 => "その他"
  }

  def str_treatment_type
    return HASH_TREATMENT_TYPE[self.treatment_type]
  end


  # current_stateの区分値(現在の状況)
  HASH_CURRENT_STATE = {
    1 => "妊娠中",
    2 => "出産した",
    3 => "治療を断念(継続しない)"
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
    99 => "それ以上",
    100 => "不明"
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
    6 => "40以上",
    99 => "不明"
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
    99 => "10.1以上",
    100 => "不明"
  }

  def str_amh
    return HASH_AMH[self.amh]
  end

  
  # types_of_eggs_and_spermの区分値(卵子と精子の帰属)
  HASH_TYPES_OF_EGGS_AND_SPERM = {
    1 => "自分自身の卵子/精子を用いた",
    2 => "提供卵子を用いた(国内)",
    3 => "提供卵子を用いた(海外)",
    4 => "提供精子を用いた(国内)",
    5 => "提供精子を用いた(海外)",
    6 => "どちらも提供卵子/精子(国内)",
    7 => "どちらも提供卵子/精子(海外)",
    8 => "どちらも提供卵子/精子(国内&海外)",
    9 => "凍結していた自分の未受精卵を用いた",
    10 => "凍結していた自分の精子を用いた",
    99 => "その他",
    100 =>"不明"
  }

  def str_types_of_eggs_and_sperm
    return HASH_TYPES_OF_EGGS_AND_SPERM[self.types_of_eggs_and_sperm]
  end


  # use_of_anesthesiaの区分値(麻酔の種類)
  HASH_USE_OF_ANESTHESIA = {
    1 => "無麻酔",
    2 => "全身麻酔",
    3 => "静脈麻酔",
    4 => "腰椎(下半身)麻酔",
    5 => "局所麻酔",
    99 => "その他",
    100 => "不明"
  }

  def str_use_of_anesthesia
    return HASH_USE_OF_ANESTHESIA[self.use_of_anesthesia]
  end


  # selection_of_anesthesia_typeの区分値(麻酔の有無&種類に関しての選択の余地)
  HASH_SELECTION_OF_ANESTHESIA_TYPE = {
    1 => "麻酔の有無のみ選択可",
    2 => "麻酔の種類(部位)のみ選択可",
    3 => "麻酔の有無&種類(部位)どちらも選択可",
    4 => "麻酔の有無&種類(部位)どちらも選択不可",
    5 => "確認していない/確認できなかった",
    99 => "その他",
    100 => "不明"
  }

  def str_selection_of_anesthesia_type
    return HASH_SELECTION_OF_ANESTHESIA_TYPE[self.selection_of_anesthesia_type]
  end


  # type_of_ovarian_stimulationの区分値(採卵周期大分類)
  HASH_TYPE_OF_OVARIAN_STIMULATION = {
    1 => "刺激なし",
    2 => "低刺激",
    3 => "中刺激",
    4 => "高刺激",
    99 => "その他",
    100 => "不明"
  }

  def str_type_of_ovarian_stimulation
    return HASH_TYPE_OF_OVARIAN_STIMULATION[self.type_of_ovarian_stimulation]
  end


  # type_of_sairan_cycleの区分値(採卵周期小分類)
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
    99 => "その他",
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

  # number_of_miscarriagesの区分値(流産回数)
  HASH_NUMBER_OF_MISCARRIAGES = {
    1 => "0回",
    2 => "1回",
    3 => "2回",
    4 => "3回以上",
    100 => "答えたくない",
  }

  def str_number_of_miscarriages
    return HASH_NUMBER_OF_MISCARRIAGES[self.number_of_miscarriages]
  end

  # number_of_stillbirthsの区分値(死産回数)
  HASH_NUMBER_OF_STILLBIRTHS = {
    1 => "0回",
    2 => "1回",
    3 => "2回",
    4 => "3回以上",
    100 => "答えたくない",
  }

  def str_number_of_stillbirths
    return HASH_NUMBER_OF_STILLBIRTHS[self.number_of_stillbirths]
  end

  # fuikuの区分値(不育症の診断有無)
  HASH_FUIKU = {
    1 => "あり",
    2 => "なし",
    99 => "答えたくない",
    100 => "不明",
  }

  def str_fuiku
    return HASH_FUIKU[self.fuiku]
  end

  # pgtの区分値(CLの実施有無)
  HASH_PGT1 = {
    1 => "公式に実施していた",
    2 => "非公式に実施していた",
    3 => "実施していると耳にしたことはある",
    4 => "実施していなかった",
    5 => "おそらく実施していなかった",
    6 => "答えたくない",
  }

  def str_pgt1
    return HASH_PGT1[self.pgt1]
  end

  # pgtの区分値(患者側の受診有無)
  HASH_PGT2 = {
    1 => "受けていない",
    2 => "このクリニックで受けた",
    3 => "別のクリニックで受けた",
    4 => "答えたくない",
  }

  def str_pgt2
    return HASH_PGT2[self.pgt2]
  end

  # adoptionの区分値(養子縁組について)
  HASH_ADOPTION = {
    1 => "検討したことがある/している",
    2 => "申請をしたことがある/している",
    3 => "養子は考えなかった/考えない",
    4 => "養子を迎え入れた",
    5 => "答えたくない",
  }

  def str_adoption
    return HASH_ADOPTION[self.adoption]
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

  # other_effort_costの区分値(CL治療以外に行なったこと/月間平均投資額)
  HASH_OTHER_EFFORT_COST = {
    1 => "3,000円未満",
    2 => "5,000円未満",
    3 => "1万円未満",
    4 => "3万円未満",
    5 => "5万円未満",
    6 => "10万円未満",
    99 => "10万円以上",
    100 => "不明",
  }

  # supplement_costの区分値(サプリ月間平均購入額)
  HASH_SUPPLEMENT_COST = {
    1 => "1,000円未満",
    2 => "2,000円未満",
    3 => "3,000円未満",
    4 => "4,000円未満",
    5 => "5,000円未満",
    6 => "6,000円未満",
    7 => "7,000円未満",
    8 => "8,000円未満",
    9 => "9,000円未満",
    10 => "1万円未満",
    11 => "1.5万円未満",
    12 => "2万円未満",
    13 => "3万円未満",
    14 => "4万円未満",
    15 => "5万円未満",
    16 => "6万円未満",
    17 => "7万円未満",
    18 => "8万円未満",
    19 => "9万円未満",
    20 => "10万円未満",
    21 => "10万円未満",
    22 => "15万円未満",
    23 => "20万円未満",
    24 => "25万円未満",
    25 => "30万円未満",
    99 => "30万円以上",
    100 => "不明",
  }

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
    22 => "220万円未満",
    23 => "230万円未満",
    24 => "240万円未満",
    25 => "250万円未満",
    26 => "260万円未満",
    27 => "270万円未満",
    28 => "280万円未満",
    29 => "290万円未満",
    30 => "300万円未満",
    31 => "310万円未満",
    32 => "320万円未満",
    33 => "330万円未満",
    34 => "340万円未満",
    35 => "350万円未満",
    36 => "360万円未満",
    37 => "370万円未満",
    38 => "380万円未満",
    39 => "390万円未満",
    40 => "400万円未満",
    41 => "410万円未満",
    42 => "420万円未満",
    43 => "430万円未満",
    44 => "440万円未満",
    45 => "450万円未満",
    46 => "460万円未満",
    47 => "470万円未満",
    48 => "480万円未満",
    49 => "490万円未満",
    50 => "500万円未満",
    51 => "510万円未満",
    52 => "520万円未満",
    53 => "530万円未満",
    54 => "540万円未満",
    55 => "550万円未満",
    56 => "560万円未満",
    57 => "570万円未満",
    58 => "580万円未満",
    59 => "590万円未満",
    60 => "600万円未満",
    61 => "610万円未満",
    62 => "620万円未満",
    63 => "630万円未満",
    64 => "640万円未満",
    65 => "650万円未満",
    66 => "660万円未満",
    67 => "670万円未満",
    68 => "680万円未満",
    69 => "690万円未満",
    70 => "700万円未満",
    71 => "710万円未満",
    72 => "720万円未満",
    73 => "730万円未満",
    74 => "740万円未満",
    75 => "750万円未満",
    76 => "760万円未満",
    77 => "770万円未満",
    78 => "780万円未満",
    79 => "790万円未満",
    80 => "800万円未満",
    81 => "810万円未満",
    82 => "820万円未満",
    83 => "830万円未満",
    84 => "840万円未満",
    85 => "850万円未満",
    86 => "860万円未満",
    87 => "870万円未満",
    88 => "880万円未満",
    89 => "890万円未満",
    90 => "900万円未満",
    91 => "910万円未満",
    92 => "920万円未満",
    93 => "930万円未満",
    94 => "940万円未満",
    95 => "950万円未満",
    96 => "960万円未満",
    97 => "970万円未満",
    98 => "980万円未満",
    99 => "990万円未満",
    100 => "1,000万円未満",
    101 => "1,500万円未満",
    102 => "2,000万円未満",
    103 => "5,000万円未満",
    104 => "5,000万円以上",
    1000 => "不明"
  }

  def str_cost
    return HASH_COST[self.cost]
  end

  # all_costの区分値(不妊治療に関する費用総額)
  HASH_ALL_COST = {
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
    22 => "220万円未満",
    23 => "230万円未満",
    24 => "240万円未満",
    25 => "250万円未満",
    26 => "260万円未満",
    27 => "270万円未満",
    28 => "280万円未満",
    29 => "290万円未満",
    30 => "300万円未満",
    31 => "310万円未満",
    32 => "320万円未満",
    33 => "330万円未満",
    34 => "340万円未満",
    35 => "350万円未満",
    36 => "360万円未満",
    37 => "370万円未満",
    38 => "380万円未満",
    39 => "390万円未満",
    40 => "400万円未満",
    41 => "410万円未満",
    42 => "420万円未満",
    43 => "430万円未満",
    44 => "440万円未満",
    45 => "450万円未満",
    46 => "460万円未満",
    47 => "470万円未満",
    48 => "480万円未満",
    49 => "490万円未満",
    50 => "500万円未満",
    51 => "510万円未満",
    52 => "520万円未満",
    53 => "530万円未満",
    54 => "540万円未満",
    55 => "550万円未満",
    56 => "560万円未満",
    57 => "570万円未満",
    58 => "580万円未満",
    59 => "590万円未満",
    60 => "600万円未満",
    61 => "610万円未満",
    62 => "620万円未満",
    63 => "630万円未満",
    64 => "640万円未満",
    65 => "650万円未満",
    66 => "660万円未満",
    67 => "670万円未満",
    68 => "680万円未満",
    69 => "690万円未満",
    70 => "700万円未満",
    71 => "710万円未満",
    72 => "720万円未満",
    73 => "730万円未満",
    74 => "740万円未満",
    75 => "750万円未満",
    76 => "760万円未満",
    77 => "770万円未満",
    78 => "780万円未満",
    79 => "790万円未満",
    80 => "800万円未満",
    81 => "810万円未満",
    82 => "820万円未満",
    83 => "830万円未満",
    84 => "840万円未満",
    85 => "850万円未満",
    86 => "860万円未満",
    87 => "870万円未満",
    88 => "880万円未満",
    89 => "890万円未満",
    90 => "900万円未満",
    91 => "910万円未満",
    92 => "920万円未満",
    93 => "930万円未満",
    94 => "940万円未満",
    95 => "950万円未満",
    96 => "960万円未満",
    97 => "970万円未満",
    98 => "980万円未満",
    99 => "990万円未満",
    100 => "1,000万円未満",
    101 => "1,500万円未満",
    102 => "2,000万円未満",
    103 => "5,000万円未満",
    104 => "5,000万円以上",
    1000 => "不明"
  }

  def str_all_cost
    return HASH_ALL_COST[self.all_cost]
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


  # reservation_methodの区分値(web予約の有無)
  HASH_RESERVATION_METHOD = {
    1 => "電話予約のみ",
    2 => "web予約のみ",
    3 => "電話･web予約どちらも",
    4 => "予約不可",
    5 => "その他",
    6 => "不明"
  }

  def str_reservation_method
    return HASH_RESERVATION_METHOD[self.reservation_method]
  end


   # average_waiting_timeの区分値(クリニックでの平均待ち時間)
   HASH_AVERAGE_WAITING_TIME = {
    1 => "30分前後",
    2 => "1時間前後",
    3 => "1.5時間前後",
    4 => "2時間前後",
    5 => "2.5時間前後",
    6 => "3時間前後",
    7 => "3.5時間前後",
    8 => "4時間前後",
    9 => "4.5時間前後",
    10 => "5時間前後",
    99 => "それ以上"
  }

  def str_average_waiting_time
    return HASH_AVERAGE_WAITING_TIME[self.average_waiting_time]
  end

  # address_at_that_timeの区分値(治療中の住まい)


  # period_of_time_spent_travelingの区分値(通院時間)
  HASH_PERIOD_OF_TIME_SPENT_TRAVELING = {
    1 => "30分前後",
    2 => "1時間前後",
    3 => "1.5時間前後",
    4 => "2時間前後",
    5 => "2.5時間前後",
    6 => "3時間前後",
    7 => "3.5時間前後",
    8 => "4時間前後",
    9 => "4.5時間前後",
    10 => "5時間前後",
    99 => "それ以上"
  }

  def str_period_of_time_spent_traveling
    return HASH_PERIOD_OF_TIME_SPENT_TRAVELING[self.period_of_time_spent_traveling]
  end


  # clinic_selection_criteriaの区分値(このクリニック選定理由)
  HASH_CLINIC_SELECTION_CRITERIA = {
    1 => "自宅から近かったから",
    2 => "職場から近かったから",
    3 => "口コミがよかったから",
    4 => "料金が手頃だったから",
    5 => "知人から勧められたから",
    6 => "説明会に参加して決めた",
    7 => "ホームページが良かった",
    8 => "広告を見て",
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
    12 => "宿泊業 飲食サービス業",
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
    3 => "非上場企業(親会社が上場)",
    4 => "国家公務員",
    100 => "不明"
  }

  def str_private_or_listed_company
    return HASH_PRIVATE_OR_LISTED_COMPANY[self.private_or_listed_company]
  end


  # domestic_or_foreign_capitalの区分値(日系or外資)
  HASH_DOMESTIC_OR_FOREIGN_CAPITAL = {
    1 => "日系企業(公務員含む)",
    2 => "外資系企業",
    99 => "その他",
    100 => "不明"
  }

  def str_domestic_or_foreign_capital
    return HASH_DOMESTIC_OR_FOREIGN_CAPITAL[self.domestic_or_foreign_capital]
  end


  # capital_sizeの区分値(資本金)
  HASH_CAPITAL_SIZE = {
    1 => "1千万円以下",
    2 => "3千万円以下",
    3 => "5千万円以下",
    4 => "1億円以下",
    5 => "3億円以下",
    6 => "10億円以下",
    7 => "50億円以下",
    8 => "100億円以下",
    9 => "それ以上",
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


  # annual_incomeの区分値(当時のご自身の年収)
  HASH_ANNUAL_INCOME = {
    1 => "50万円未満",
    2 => "100万円未満",
    3 => "200万円未満",
    4 => "300万円未満",
    5 => "400万円未満",
    6 => "500万円未満",
    7 => "600万円未満",
    8 => "700万円未満",
    9 => "800万円未満",
    10 => "900万円未満",
    11 => "1,000万円未満",
    12 => "1,500万円未満",
    13 => "2,000万円未満",
    14 => "2,000万円以上"
  }

  def str_annual_income
    return HASH_ANNUAL_INCOME[self.annual_income]
  end


  # household_net_incomeの区分値(当時、前年の夫婦合算所得)
  HASH_HOUSEHOLD_NET_INCOME = {
    1 => "50万円未満",
    2 => "100万円未満",
    3 => "200万円未満",
    4 => "300万円未満",
    5 => "400万円未満",
    6 => "500万円未満",
    7 => "600万円未満",
    8 => "730万円未満",
    9 => "800万円未満",
    10 => "905万円未満",
    11 => "1,000万円未満",
    12 => "1,500万円未満",
    13 => "2,000万円未満",
    14 => "2,000万円以上"
  }

  def str_household_net_income
    return HASH_HOUSEHOLD_NET_INCOME[self.household_net_income]
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
    1 => "もとから非喫煙者",
    2 => "元喫煙者だが治療以前にやめていた",
    3 => "治療のために禁煙した",
    4 => "禁煙しなかった",
    99 => "その他"
  }

  def str_smoking
    return HASH_SMOKING[self.smoking]
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

  # itinerary_of_choosing_a_clinicsのorder_of_transfer区分値(転院履歴)別モデル
  def self.make_select_itinerary_of_choosing_a_clinics_order_of_transfer
    hash = {}
    (1..20).each do |i|
      hash["#{i}つ前のCL"] = i
    end
    hash
  end

  # sairan_hormoneのday区分値(採卵時のホルモン値)別モデル
  def self.make_select_sairan_hormone_day
    hash = {}
    (1..100).each do |i|
      hash["D#{i}"] = i
    end
    hash
  end

  # shokihaiishoku_hormoneのet区分値(初期胚移植のホルモン値)別モデル
  def self.make_select_shokihaiishoku_hormone_day
    hash = {}
    (1..100).each do |i|
      hash["ET#{i}"] = i
    end
    hash
  end

  # haibanhoishoku_hormoneのbt区分値(胚盤胞移植のホルモン値)別モデル
  def self.make_select_haibanhoishoku_hormone_day
    hash = {}
    (1..100).each do |i|
      hash["BT#{i}"] = i
    end
    hash
  end
  
  # fertility_treatment_numberの区分値(何人目か)
  FERTILITY_TREATMENT_NUMBER_UNIT = "人目不妊"
  FERTILITY_TREATMENT_NUMBER_MAXIMUM = 1000
  FERTILITY_TREATMENT_NUMBER_RANGE = 2
  UPPER_THE_FERTILITY_TREATMENT_NUMBER_RANGE = FERTILITY_TREATMENT_NUMBER_RANGE + 1
  STR_FERTILITY_TREATMENT_NUMBER_MAXIMUM = "#{UPPER_THE_FERTILITY_TREATMENT_NUMBER_RANGE}#{FERTILITY_TREATMENT_NUMBER_UNIT}#{OR_MORE}"

  def str_fertility_treatment_number
    return "" if self.fertility_treatment_number.nil?
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
    return "" if self.number_of_clinics.nil?
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
    return "" if self.number_of_aih.nil?
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


  # first_age_to_startの区分値(治療開始年齢/妊活〜不妊治療全体)
  FIRST_AGE_TO_START_MAXIMUM = 1000
  FIRST_AGE_TO_START_RANGE = 59
  UPPER_THE_FIRST_AGE_TO_START_RANGE = FIRST_AGE_TO_START_RANGE + 1
  STR_FIRST_AGE_TO_START_MAXIMUM = "#{UPPER_THE_FIRST_AGE_TO_START_RANGE}#{AGE}#{OR_MORE}"
  STR_FIRST_AGE_TO_START_MINIMUM = "#{THE_BEGINNING_OF_AGE}#{AGE}#{OR_LESS}"

  def str_first_age_to_start
    return "" if self.first_age_to_start.nil?
    if self.first_age_to_start == FIRST_AGE_TO_START_MAXIMUM
      STR_FIRST_AGE_TO_START_MAXIMUM
    elsif self.first_age_to_start <= THE_BEGINNING_OF_AGE
      STR_FIRST_AGE_TO_START_MINIMUM
    elsif self.first_age_to_start > THE_BEGINNING_OF_AGE || self.first_age_to_start <= FIRST_AGE_TO_START_RANGE
      "#{self.first_age_to_start} #{AGE}"
    else
      raise
    end
  end
  
  def self.make_select_options_first_age_to_start
    hash = {}
    (THE_BEGINNING_OF_AGE..FIRST_AGE_TO_START_RANGE).each do |i|
      if i == THE_BEGINNING_OF_AGE
        hash[STR_FIRST_AGE_TO_START_MINIMUM] = i
      else
        hash["#{i}#{AGE}"] = i
      end
    end
    hash[STR_FIRST_AGE_TO_START_MAXIMUM] = STR_FIRST_AGE_TO_START_MAXIMUM
    hash
  end


  # treatment_start_ageの区分値(治療開始年齢/CL単位)
  TREATMENT_START_AGE_MAXIMUM = 1000
  TREATMENT_START_AGE_RANGE = 59
  UPPER_THE_TREATMENT_START_AGE_RANGE = TREATMENT_START_AGE_RANGE + 1
  STR_TREATMENT_START_AGE_MAXIMUM = "#{UPPER_THE_TREATMENT_START_AGE_RANGE}#{AGE}#{OR_MORE}"
  STR_TREATMENT_START_AGE_MINIMUM = "#{THE_BEGINNING_OF_AGE}#{AGE}#{OR_LESS}"

  def str_treatment_start_age
    return "" if self.treatment_start_age.nil?
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
    return "" if self.treatment_end_age.nil?
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
    return "" if self.total_number_of_sairan.nil?
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
    return "" if self.all_number_of_sairan.nil?
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
    return "" if self.total_number_of_transplants.nil?
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
    return "" if self.all_number_of_transplants.nil?
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
    return "" if self.number_of_eggs_collected.nil?
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
    return "" if self.number_of_fertilized_eggs.nil?
    if self.number_of_fertilized_eggs == NUMBER_OF_FERTILIZED_EGGS_MAXIMUM
      STR_NUMBER_OF_FERTILIZED_EGGS_MAXIMUM
    elsif self.number_of_fertilized_eggs >= 1 || self.number_of_fertilized_eggs <= NUMBER_OF_FERTILIZED_EGGS_RANGE
      "#{self.number_of_fertilized_eggs} #{PIECES}"
    else
      raise
    end
  end

  def self.make_select_options_number_of_fertilized_eggs
    hash = {}
    (1..NUMBER_OF_FERTILIZED_EGGS_RANGE).each do |i|
      hash["#{i}#{PIECES}"] = i
    end
    hash[STR_NUMBER_OF_FERTILIZED_EGGS_MAXIMUM] = STR_NUMBER_OF_FERTILIZED_EGGS_MAXIMUM
    hash[STR_UNKNOWN] = STR_UNKNOWN
    hash
  end

  # number_of_transferable_embryosの区分値(最新採卵周期での受精した個数/CL単位)
  NUMBER_OF_TRANSFERABLE_EMBRYOS_MAXIMUM = 1000
  NUMBER_OF_TRANSFERABLE_EMBRYOS_RANGE = 50
  STR_NUMBER_OF_TRANSFERABLE_EMBRYOS_MAXIMUM = "それ#{OR_MORE}"

  def str_number_of_transferable_embryos
    return "" if self.number_of_transferable_embryos.nil?
    if self.number_of_transferable_embryos == NUMBER_OF_TRANSFERABLE_EMBRYOS_MAXIMUM
      STR_NUMBER_OF_TRANSFERABLE_EMBRYOS_MAXIMUM
    elsif self.number_of_transferable_embryos >= 1 || self.number_of_transferable_embryos <= NUMBER_OF_TRANSFERABLE_EMBRYOS_RANGE
      "#{self.number_of_transferable_embryos} #{PIECES}"
    else
      raise
    end
  end

  def self.make_select_options_number_of_transferable_embryos
    hash = {}
    (1..NUMBER_OF_TRANSFERABLE_EMBRYOS_RANGE).each do |i|
      hash["#{i}#{PIECES}"] = i
    end
    hash[STR_NUMBER_OF_TRANSFERABLE_EMBRYOS_MAXIMUM] = STR_NUMBER_OF_TRANSFERABLE_EMBRYOS_MAXIMUM
    hash[STR_UNKNOWN] = STR_UNKNOWN
    hash
  end

  # number_of_frozen_eggsの区分値(最新周期での凍結できた数/CL単位)
  NUMBER_OF_FROZEN_EGGS_MAXIMUM = 1000
  NUMBER_OF_FROZEN_EGGS_RANGE = 50
  STR_NUMBER_OF_FROZEN_EGGS_MAXIMUM = "それ#{OR_MORE}"

  def str_number_of_frozen_eggs
    return "" if self.number_of_frozen_eggs.nil?
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
    return "" if self.number_of_eggs_stored.nil?
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
    (0..NUMBER_OF_EGGS_STORED_RANGE).each do |i|
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
    return "" if self.embryo_culture_days.nil?
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

  # embryo_grade_sizeの区分値(妊娠に至った胚の大きさ) 
  HASH_EMBRYO_GRADE_SIZE = { "1" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "その他" => 99, "不明" => 100 }
  EMBRYO_GRADE_SIZE_MAXIMUM = 1000
  EMBRYO_GRADE_SIZE_RANGE = 10
  STR_EMBRYO_GRADE_SIZE_MAXIMUM = "それ#{DAY}#{OR_MORE}"

  def str_embryo_grade_size
    return "" if self.embryo_grade_size.nil?
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
#  id                                           :bigint           not null, primary key
#  adoption                                     :integer
#  all_cost                                     :integer
#  all_number_of_sairan                         :integer
#  all_number_of_transplants                    :integer
#  amh                                          :integer
#  annual_income                                :integer
#  annual_income_status                         :integer          default("show"), not null
#  average_waiting_time                         :integer
#  blastocyst_grade1                            :integer
#  blastocyst_grade1_supplementary_explanation  :text
#  blastocyst_grade2                            :integer
#  blastocyst_grade2_supplementary_explanation  :text
#  bmi                                          :integer
#  capital_size                                 :integer
#  city_at_the_time_status                      :integer          default("show"), not null
#  clinic_review                                :text
#  clinic_selection_criteria                    :integer
#  content                                      :text
#  cost                                         :integer
#  credit_card_validity                         :integer
#  creditcards_can_be_used_from_more_than       :integer
#  current_state                                :integer
#  department                                   :integer
#  domestic_or_foreign_capital                  :integer
#  early_embryo_grade                           :integer
#  early_embryo_grade_supplementary_explanation :text
#  egg_maturity                                 :integer
#  embryo_culture_days                          :integer
#  embryo_stage                                 :integer
#  explanation_of_frozen_embryo_storage_cost    :text
#  fertility_treatment_number                   :integer
#  first_age_to_start                           :integer
#  frozen_embryo_storage_cost                   :integer
#  fuiku                                        :integer
#  fuiku_supplementary_explanation              :text
#  household_net_income                         :integer
#  household_net_income_status                  :integer          default("show"), not null
#  industry_type                                :integer
#  notes_on_type_of_sairan_cycle                :text
#  number_of_aih                                :integer
#  number_of_clinics                            :integer
#  number_of_eggs_collected                     :integer
#  number_of_eggs_stored                        :integer
#  number_of_employees                          :integer
#  number_of_fertilized_eggs                    :integer
#  number_of_frozen_eggs                        :integer
#  number_of_miscarriages                       :integer
#  number_of_stillbirths                        :integer
#  number_of_transferable_embryos               :integer
#  other_effort_cost                            :integer
#  other_effort_supplementary_explanation       :text
#  ova_with_ivm                                 :integer
#  period_of_time_spent_traveling               :integer
#  pgt1                                         :integer
#  pgt2                                         :integer
#  pgt_supplementary_explanation                :text
#  position                                     :integer
#  prefecture_at_the_time_status                :integer          default("show"), not null
#  private_or_listed_company                    :integer
#  reasons_for_choosing_this_clinic             :text
#  reservation_method                           :integer
#  selection_of_anesthesia_type                 :integer
#  smoking                                      :integer
#  special_inspection_supplementary_explanation :text
#  status                                       :integer          default("released"), not null
#  supplement_cost                              :integer
#  supplement_supplementary_explanation         :text
#  suspended_or_retirement_job                  :integer
#  title                                        :string
#  total_number_of_sairan                       :integer
#  total_number_of_transplants                  :integer
#  treatment_end_age                            :integer
#  treatment_period                             :integer
#  treatment_start_age                          :integer
#  treatment_support_system                     :integer
#  treatment_type                               :integer
#  type_of_ovarian_stimulation                  :integer
#  type_of_sairan_cycle                         :integer
#  types_of_eggs_and_sperm                      :integer
#  types_of_fertilization_methods               :integer
#  use_of_anesthesia                            :integer
#  work_style                                   :integer
#  year_of_treatment_end                        :date
#  created_at                                   :datetime         not null
#  updated_at                                   :datetime         not null
#  city_id                                      :bigint
#  clinic_id                                    :bigint           not null
#  prefecture_id                                :bigint
#  user_id                                      :bigint           not null
#
# Indexes
#
#  index_reports_on_city_id        (city_id)
#  index_reports_on_clinic_id      (clinic_id)
#  index_reports_on_prefecture_id  (prefecture_id)
#  index_reports_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (clinic_id => clinics.id)
#  fk_rails_...  (prefecture_id => prefectures.id)
#  fk_rails_...  (user_id => users.id)
#