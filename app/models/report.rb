class Report < ApplicationRecord

  # レポートの公開状況 参考:https://qiita.com/tomoharutt/items/f1a70babaddcf7ab47be
  enum status: { released: 0, nonreleased: 1 }

  # 仕事セクションの(年収などの項目）公開状況 参考:https://qiita.com/emacs_hhkb/items/fce19f443e5770ad2e13
  enum work_style_status: { show: 0, hide: 1 }, _prefix: true
  enum industry_type_status: { show: 0, hide: 1 }, _prefix: true
  enum private_or_listed_company_status: { show: 0, hide: 1 }, _prefix: true
  enum domestic_or_foreign_capital_status: { show: 0, hide: 1 }, _prefix: true
  enum capital_size_status: { show: 0, hide: 1 }, _prefix: true
  enum department_status: { show: 0, hide: 1 }, _prefix: true
  enum position_status: { show: 0, hide: 1 }, _prefix: true
  enum number_of_employees_status: { show: 0, hide: 1 }, _prefix: true
  enum annual_income_status: { show: 0, hide: 1 }, _prefix: true
  enum household_net_income_status: { show: 0, hide: 1 }, _prefix: true

  # 治療当時の住まいの公開状況 参考:http://mnmandahalf.hatenablog.com/entry/2017/08/20/164442
  enum prefecture_at_the_time_status: { show: 0, hide: 1 }, _prefix: true
  enum city_at_the_time_status: { show: 0, hide: 1 }, _prefix: true

  # PGT-Aの公開状況
  enum pgt1_status: { show: 0, hide: 1 }, _prefix: true
  enum pgt2_status: { show: 0, hide: 1 }, _prefix: true
  enum pgt_supplementary_explanation_status: { show: 0, hide: 1 }, _prefix: true


  # バリデーション
  validates :title, length: { maximum: 64 }
  # validate :validate_treatment_age
  # validate :validate_all_treatment_age
  # validate :validate_all_number_of_sairan
  # validate :validate_all_number_of_transplants
  validate :validate_content_length
  validate :validate_content_attachment_byte_size
  validate :validate_content_attachments_count
  # validate :validate_content_report_count

  MAX_CONTENT_LENGTH = 30000
  MEGA_BYTES = 3
  ONE_KILOBYTE = 1024
  MAX_CONTENT_ATTACHMENT_BYTE_SIZE = MEGA_BYTES * 1_000 * ONE_KILOBYTE
  MAX_CONTENT_ATTACHMENTS_COUNT = 4

  # def validate_treatment_age
  #   return "" if self.treatment_start_age.nil?
  #   return "" if self.treatment_end_age.nil?
  #   if treatment_start_age > treatment_end_age
  #     errors.add(
  #       :base,
  #       :treatment_end_age_is_earlier_than_treatment_start_age
  #     )
  #   end
  # end

  # def validate_all_treatment_age
  #   return "" if self.first_age_to_start.nil?
  #   return "" if self.treatment_start_age.nil?
  #   if first_age_to_start > treatment_start_age
  #     errors.add(
  #       :base,
  #       :cl_treatment_start_age_is_earlier_than_first_start_age
  #     )
  #   end
  # end

  # def validate_all_number_of_sairan
  #   return "" if self.total_number_of_sairan.nil?
  #   return "" if self.all_number_of_sairan.nil?
  #   if total_number_of_sairan > all_number_of_sairan
  #     errors.add(
  #       :base,
  #       :the_number_of_sairan_at_this_clinic_exceeds_the_cumulative_total
  #     )
  #   end
  # end

  # def validate_all_number_of_transplants
  #   return "" if self.total_number_of_transplants.nil?
  #   return "" if self.all_number_of_transplants.nil?
  #   if total_number_of_transplants > all_number_of_transplants
  #     errors.add(
  #       :base,
  #       :number_of_transplants_at_this_clinic_exceeds_cumulative_total
  #     )
  #   end
  # end

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

  def normalize_for_create_embryo_stage
    if self.embryo_stage == 1
      self.blastocyst_grade1 = nil
      self.blastocyst_grade2 = nil
      self.day_of_haibanhoishokus = []
      self.haibanhoishoku_hormones = []
    elsif self.embryo_stage == 2
      self.early_embryo_grade = nil
      self.day_of_shokihaiishokus = []
      self.shokihaiishoku_hormones = []
    else
      self.early_embryo_grade = nil
      self.blastocyst_grade1 = nil
      self.blastocyst_grade2 = nil
      self.day_of_shokihaiishokus = []
      self.shokihaiishoku_hormones = []
      self.day_of_haibanhoishokus = []
      self.haibanhoishoku_hormones = []
    end
  end

  def normalize_for_credit_card_validity
    unless self.credit_card_validity == 3
      self.creditcards_can_be_used_from_more_than = nil
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
  belongs_to :prefecture
  belongs_to :city

  # ---子---
    # 転院遍歴
    has_many :itinerary_of_choosing_a_clinics, dependent: :destroy
    accepts_nested_attributes_for :itinerary_of_choosing_a_clinics, reject_if: :all_blank, allow_destroy: true, update_only: true
    def reject_itinerary_of_choosing_a_clinics(attributes)
      exists = attributes[:id].present?
      empty = attributes[:email].blank?
      attributes.merge!(_destroy: 1) if exists && empty
      !exists && empty
    end

    # コメント
    has_many :comments, dependent: :destroy

    # いいね
    has_many :likes, dependent: :destroy

    # 通知モデル
    has_many :notifications, dependent: :destroy

    def create_notification_comment!(current_user, comment_id)
      # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
      temp_ids = Comment.select(:user_id).where(report_id: id).where.not(user_id: current_user.id).distinct
      temp_ids.each do |temp_id|
        save_notification_comment!(current_user, comment_id, temp_id['user_id'])
      end
      # まだ誰もコメントしていない場合は、投稿者に通知を送る
      save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
    end
  
    def save_notification_comment!(current_user, comment_id, visited_id)
      # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
      notification = current_user.active_notifications.new(
        report_id: id,
        comment_id: comment_id,
        visited_id: visited_id,
        action: 'comment'
      )
      # 自分の投稿に対するコメントの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end

    # 採卵日当日のホルモン
    has_many :day_of_sairans, inverse_of: :report, dependent: :destroy
    accepts_nested_attributes_for :day_of_sairans, reject_if: :all_blank, allow_destroy: true, update_only: true

    # 採卵周期のホルモン
    has_many :sairan_hormones, inverse_of: :report, dependent: :destroy
    accepts_nested_attributes_for :sairan_hormones, reject_if: :all_blank, allow_destroy: true, update_only: true

    # 移植前のホルモン
    has_many :before_ishoku_hormones, inverse_of: :report, dependent: :destroy
    accepts_nested_attributes_for :before_ishoku_hormones, reject_if: :all_blank, allow_destroy: true, update_only: true

    # 初期胚移植日当日のホルモン
    has_many :day_of_shokihaiishokus, inverse_of: :report, dependent: :destroy
    accepts_nested_attributes_for :day_of_shokihaiishokus, reject_if: :all_blank, allow_destroy: true, update_only: true

    # 胚盤胞胚移植日当日のホルモン
    has_many :day_of_haibanhoishokus, inverse_of: :report, dependent: :destroy
    accepts_nested_attributes_for :day_of_haibanhoishokus, reject_if: :all_blank, allow_destroy: true, update_only: true

    # 初期胚移植周期のホルモン
    has_many :shokihaiishoku_hormones, inverse_of: :report, dependent: :destroy
    accepts_nested_attributes_for :shokihaiishoku_hormones, reject_if: :all_blank, allow_destroy: true, update_only: true

    # 胚盤胞移植周期のホルモン
    has_many :haibanhoishoku_hormones, inverse_of: :report, dependent: :destroy
    accepts_nested_attributes_for :haibanhoishoku_hormones, reject_if: :all_blank, allow_destroy: true, update_only: true

    # 特殊検査（ERAなど）
    has_many :special_inspections, inverse_of: :report, dependent: :destroy
    accepts_nested_attributes_for :special_inspections, reject_if: :all_blank, allow_destroy: true, update_only: true

  # 検索
  def self.search(search)
    if search
      where(['name LIKE ?', "%#{search}%"])
    else
      all
    end
  end

  # 精子選抜方法
  has_many :report_s_selection_methods, dependent: :destroy
  has_many :s_selection_methods, through: :report_s_selection_methods

  def save_ssms(ssm_list)
    current_ssms = self.s_selection_methods.pluck(:name) unless self.s_selection_methods.nil?
    old_ssms = current_ssms - ssm_list
    new_ssms = ssm_list - current_ssms

    # Destroy old s_selection_methods:
    old_ssms.each do |old_name|
      self.s_selection_methods.delete SSelectionMethod.find_by(name: old_name)
    end

    # Create new s_selection_methods:
    new_ssms.each do |new_name|
      report_ssm = SSelectionMethod.find_or_create_by(name: new_name)
      self.s_selection_methods << report_ssm
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

  # def save_sods(sod_list)
  #   current_sods = self.scope_of_disclosures.pluck(:scope) unless self.scope_of_disclosures.nil?
  #   old_sods = current_sods - sod_list
  #   new_sods = sod_list - current_sods

    # Destroy old scope_of_disclosures:
    # old_sods.each do |old_scope|
    #   self.scope_of_disclosures.delete ScopeOfDisclosure.find_by(scope: old_scope)
    # end

    # Create new scope_of_disclosures:
  #   new_sods.each do |new_scope|
  #     report_sod = ScopeOfDisclosure.find_or_create_by(scope: new_scope)
  #     self.scope_of_disclosures << report_sod
  #   end
  # end

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

  # current_stateの区分値(現在の状況)
  HASH_CURRENT_STATE = {
    1 => "妊娠中",
    2 => "妊娠中（双子）",
    3 => "出産済み",
    4 => "出産済み（双子）",
    5 => "出産に至らず",
    6 => "転院した",
    7 => "治療自体を完全にやめた",
    99 => "その他"
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
    1 => "自身＆パートナーの卵子/精子を用いた",
    2 => "自身＆パートナーの凍結未受精卵を用いた",
    3 => "自身＆パートナーの凍結精子を用いた",
    4 => "提供卵子を用いた",
    5 => "提供精子を用いた",
    99 => "その他",
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
    1 => "選択できなかった",
    2 => "選択できた",
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
    6 => "ウルトラロング法",
    7 => "ショート法",
    8 => "アンタゴニスト法",
    99 => "その他",
    100 => "不明"
  }

  def str_type_of_sairan_cycle
    return HASH_TYPE_OF_SAIRAN_CYCLE[self.type_of_sairan_cycle]
  end

  # types_of_fertilization_methodsの区分値(受精方法)
  HASH_TYPES_OF_FERTILIZATION_METHODS = {
    1 => "体外受精",
    2 => "顕微授精",
    3 => "スプリット(体外･顕微両方)",
    99 => "その他",
    100 => "不明"
  }

  def str_types_of_fertilization_methods
    return HASH_TYPES_OF_FERTILIZATION_METHODS[self.types_of_fertilization_methods]
  end

  # details_of_icsiの区分値(顕微授精の詳細)
  HASH_DETAILS_OF_ICSI = {
    1 => "ICSI",
    2 => "ピエゾICSI",
    3 => "IMSI",
    99 => "その他",
    100 => "不明"
  }

  def str_details_of_icsi
    return HASH_DETAILS_OF_ICSI[self.details_of_icsi]
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

  def str_transplant_method
    return HASH_TRANSPLANT_METHOD[self.transplant_method]
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

  # number_of_miscarriagesの区分値(化学流産回数)
  HASH_NUMBER_OF_MISCARRIAGES = {
    1 => "なし",
    2 => "1回",
    3 => "2回",
    4 => "3回以上",
    100 => "無回答",
  }

  def str_number_of_miscarriages
    return HASH_NUMBER_OF_MISCARRIAGES[self.number_of_miscarriages]
  end

  # number_of_stillbirthsの区分値(死産回数)
  HASH_NUMBER_OF_STILLBIRTHS = {
    1 => "なし",
    2 => "1回",
    3 => "2回",
    4 => "3回以上",
    100 => "無回答",
  }

  def str_number_of_stillbirths
    return HASH_NUMBER_OF_STILLBIRTHS[self.number_of_stillbirths]
  end

  # fuikuの区分値(不育症の診断有無)
  HASH_FUIKU = {
    1 => "なし",
    2 => "あり",
    99 => "無回答",
    100 => "不明",
  }

  def str_fuiku
    return HASH_FUIKU[self.fuiku]
  end

  # pgtの区分値(CLの実施有無)
  HASH_PGT1 = {
    1 => "公に実施していた",
    2 => "PGT臨床研究機関に指定されていた",
    3 => "非公式に実施していた",
    4 => "実施していると耳にしたことはある",
    5 => "実施していなかった",
    6 => "おそらく実施していなかった",
    7 => "無回答",
    8 => "わからない",
  }

  def str_pgt1
    return HASH_PGT1[self.pgt1]
  end

  # pgtの区分値(患者側の受診有無)
  HASH_PGT2 = {
    1 => "受けていない",
    2 => "このクリニックで受けた",
    3 => "別のクリニックで受けた",
    4 => "無回答",
  }

  def str_pgt2
    return HASH_PGT2[self.pgt2]
  end

  # adoptionの区分値(養子縁組について)
  HASH_ADOPTION = {
    1 => "全く考えなかった/考えない",
    2 => "考えたことはある",
    3 => "具体的に検討した/している",
    4 => "申請をした/している",
    5 => "養子を迎え入れた",
    6 => "無回答",
  }

  def str_adoption
    return HASH_ADOPTION[self.adoption]
  end

  # ova_with_ivmの区分値(妊娠に至った卵子へのIVMの有無)
  HASH_OVA_WITH_IVM = {
    1 => "なし",
    2 => "あり",
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

  def str_other_effort_cost
    return HASH_OTHER_EFFORT_COST[self.other_effort_cost]
  end

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

  def str_supplement_cost
    return HASH_SUPPLEMENT_COST[self.supplement_cost]
  end

  # sairan_costの区分値(CLでの1回あたりの採卵費用)
  HASH_SAIRAN_COST = {
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
    99 => "それ以上",
    100 => "不明"
  }

  def str_sairan_cost
    return HASH_SAIRAN_COST[self.sairan_cost]
  end

  # ishoku_costの区分値(CLでの1回あたりの移植費用)
  HASH_ISHOKU_COST = {
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
    99 => "それ以上",
    100 => "不明"
  }

  def str_ishoku_cost
    return HASH_ISHOKU_COST[self.ishoku_cost]
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

   # number_of_times_the_grant_was_receivedの区分値(助成金受給回数)
   HASH_NUMBER_OF_TIMES_THE_GRANT_WAS_RECEIVED = {
    1 => "0回",
    2 => "1回",
    3 => "2回",
    4 => "3回",
    5 => "4回",
    6 => "5回",
    7 => "6回",
    99 => "その他",
    100 => "不明"
  }

  def str_number_of_times_the_grant_was_received
    return HASH_NUMBER_OF_TIMES_THE_GRANT_WAS_RECEIVED[self.number_of_times_the_grant_was_received]
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

  # online_consultationの区分値(オンライン診療の有無)
  HASH_ONLINE_CONSULTATION = {
    1 => "なし",
    2 => "あり(初診は除く)",
    3 => "あり(初診もOK)",
    99 => "不明"
  }

  def str_online_consultation
    return HASH_ONLINE_CONSULTATION[self.online_consultation]
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
    3 => "口コミサイトで評価が良かったから",
    4 => "SNSでの評判を見て",
    5 => "料金が手頃だったから",
    6 => "知人から勧められたから",
    7 => "説明会に参加して決めた",
    8 => "ホームページをみて",
    9 => "信頼する医師がいたから",
    10 => "広告を見て",
    99 => "その他"
    }

  def str_clinic_selection_criteria
    return HASH_CLINIC_SELECTION_CRITERIA[self.clinic_selection_criteria]
  end

  # briefing_sessionの区分値(説明会への有無と参加)
  HASH_BRIEFING_SESSION = {
    1 => "リアル説明会に参加した",
    2 => "オンライン説明会に参加した",
    3 => "リアル/オンライン どちらにも参加した",
    4 => "リアル/オンライン どちらの説明会へも参加しなかった",
    5 => "説明会自体がなかった",
    99 => "その他"
    }

  def str_briefing_session
    return HASH_BRIEFING_SESSION[self.briefing_session]
  end

  # industry_typeの区分値(業種) ※参考→業種コード表（日本標準産業分類）
  # 11→メーカー、12→商社、13→小売、14→金融、15→サービス、16→ソフトウェア･IT、17→マスコミ、18→官公庁･公社･団体
  # https://shinsotsu.mynavi-agent.jp/ryugakusei/knowhow/article/international-job-category.html
  HASH_INDUSTRY_TYPE = {
    1101 => "食品",
    1102 => "農林",
    1103 => "水産",
    1104 => "建設",
    1105 => "住宅",
    1106 => "インテリア",
    1107 => "繊維",
    1108 => "化学",
    1109 => "薬品",
    1110 => "化粧品",
    1111 => "鉄鋼",
    1112 => "金属",
    1113 => "鉱業",
    1114 => "機械",
    1115 => "プラント",
    1116 => "電子",
    1117 => "電気機器",
    1118 => "自動車",
    1119 => "輸送用機器",
    1120 => "精密",
    1121 => "医療機器",
    1122 => "印刷",
    1123 => "事務機器関連",
    1124 => "スポーツ",
    1125 => "玩具",
    1199 => "その他",
    1201 => "総合商社",
    1202 => "専門商社",
    1301 => "百貨店",
    1302 => "スーパー",
    1303 => "コンビニ",
    1304 => "専門店(小売)",
    1401 => "銀行",
    1402 => "証券",
    1403 => "クレジット",
    1404 => "信販",
    1405 => "リース",
    1406 => "その他金融",
    1407 => "生保",
    1408 => "損保",
    1501 => "不動産",
    1502 => "鉄道",
    1503 => "航空",
    1504 => "運輸",
    1505 => "物流",
    1506 => "電力",
    1507 => "ガス",
    1508 => "エネルギー",
    1509 => "フードサービス",
    1510 => "ホテル",
    1511 => "旅行",
    1512 => "医療",
    1513 => "福祉",
    1514 => "アミューズメント",
    1515 => "レジャー",
    1516 => "その他サービス",
    1517 => "コンサルティング",
    1518 => "調査",
    1519 => "人材サービス",
    1520 => "教育",
    1601 => "ソフトウエア",
    1602 => "インターネット",
    1603 => "通信",
    1701 => "放送",
    1702 => "新聞",
    1703 => "出版",
    1704 => "広告",
    1801 => "公社･団体",
    1802 => "官公庁",
    9999 => "その他"
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
    1 => "有り",
    2 => "無し",
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
    2 => "元喫煙者だが治療以前に禁煙済み",
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

  # day_of_sairanの区分値(採卵当日のホルモン値)別モデル
  def self.make_select_day_of_sairan
    hash = {}
    (1..100).each do |i|
      hash["D#{i}"] = i
    end
    hash
  end

  # day_of_shokihaiishokuの区分値(初期胚移植当日のホルモン値)別モデル
  def self.make_select_day_of_shokihaiishoku
    hash = {}
    (1..100).each do |i|
      hash["D#{i}"] = i
    end
    hash
  end

  # day_of_haibanhoishokuの区分値(胚盤胞移植当日のホルモン値)別モデル
  def self.make_select_day_of_haibanhoishoku
    hash = {}
    (0..100).each do |i|
      hash["D#{i}"] = i
    end
    hash
  end

  # sairan_hormoneのday区分値(採卵周期のホルモン値)別モデル
  def self.make_select_sairan_hormone_day
    hash = {}
    (1..100).each do |i|
      hash["D#{i}"] = i
    end
    hash
  end

  # before_ishoku_hormoneのday区分値(移植前のホルモン値)別モデル
  def self.make_select_before_ishoku_hormone_day
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

  # special_inspectionの区分値(特殊検査)別モデル
    # name
    HASH_SPECIAL_INSPECTION_NAME = {
      1 => "エラ(ERA)",
      2 => "エマ(EMMA)",
      3 => "アリス(ALICE)",
      4 => "トリオ(TORIO)",
      5 => "ERPeak",
      6 => "子宮内膜組織診",
      7 => "子宮内フローラ",
      8 => "慢性子宮内膜炎(CD138/BCE)",
      9 => "子宮鏡検査",
      10 => "染色体検査",
      11 => "CA125",
      12 => "MRI",
      13 => "ビタミンD検査",
      14 => "銅亜鉛検査",
      15 => "精子検査(クルーガーテスト)",
      99 => "その他",
    }

    def str_special_inspection_name
      return HASH_SPECIAL_INSPECTION_NAME[SpecialInspection.name]
    end

    # place
    HASH_SPECIAL_INSPECTION_PLACE = {
      1 => "このクリニックで",
      2 => "別のクリニックで",
    }

    def str_special_inspection_place
      return HASH_SPECIAL_INSPECTION_PLACE[a]
    end

    # timing
    def self.make_select_special_inspection_timing
      hash = {}
      (1..100).each do |i|
        hash["D#{i}"] = i
      end
      hash
    end


  # fertility_treatment_numberの区分値(何人目か)
  HASH_FERTILITY_TREATMENT_NUMBER = {
    1 => "1人目",
    2 => "2人目",
    3 => "3人以上",
  }

  def str_fertility_treatment_number
    return HASH_FERTILITY_TREATMENT_NUMBER[self.fertility_treatment_number]
  end
  # FERTILITY_TREATMENT_NUMBER_UNIT = "人目不妊"
  # FERTILITY_TREATMENT_NUMBER_MAXIMUM = 1000
  # FERTILITY_TREATMENT_NUMBER_RANGE = 2
  # UPPER_THE_FERTILITY_TREATMENT_NUMBER_RANGE = FERTILITY_TREATMENT_NUMBER_RANGE + 1
  # STR_FERTILITY_TREATMENT_NUMBER_MAXIMUM = "#{UPPER_THE_FERTILITY_TREATMENT_NUMBER_RANGE}#{FERTILITY_TREATMENT_NUMBER_UNIT}#{OR_MORE}"

  # def str_fertility_treatment_number
  #   return "" if self.fertility_treatment_number.nil?
  #   if self.fertility_treatment_number == FERTILITY_TREATMENT_NUMBER_MAXIMUM
  #     STR_FERTILITY_TREATMENT_NUMBER_MAXIMUM
  #   elsif self.fertility_treatment_number >= 1 || self.fertility_treatment_number <= FERTILITY_TREATMENT_NUMBER_RANGE
  #     "#{self.fertility_treatment_number} #{FERTILITY_TREATMENT_NUMBER_UNIT}"
  #   else
  #     raise
  #   end
  # end

  # def self.make_select_options_fertility_treatment_number
  #   hash = {}
  #   (1..FERTILITY_TREATMENT_NUMBER_RANGE).each do |i|
  #     hash["#{i}#{FERTILITY_TREATMENT_NUMBER_UNIT}"] = i
  #   end
  #   hash[STR_FERTILITY_TREATMENT_NUMBER_MAXIMUM] = STR_FERTILITY_TREATMENT_NUMBER_MAXIMUM
  #   hash
  # end

  # number_of_clinicsの区分値(何院目か)
  HASH_NUMBER_OF_CLINICS = {
    1 => "1院目",
    2 => "2院目",
    3 => "3院目",
    4 => "4院目",
    5 => "5院目",
    6 => "6院目",
    7 => "7院目",
    8 => "8院目",
    9 => "9院目",
    10 => "10院目",
    99 => "11院目以上",
    100 => "不明",
  }

  def str_number_of_clinics
    return HASH_NUMBER_OF_CLINICS[self.number_of_clinics]
  end
  # NUMBER_OF_CLINICS_UNIT = "院目"
  # NUMBER_OF_CLINICS_MAXIMUM = 1000
  # NUMBER_OF_CLINICS_RANGE = 10
  # UPPER_THE_NUMBER_OF_CLINICS_RANGE = NUMBER_OF_CLINICS_RANGE + 1
  # STR_NUMBER_OF_CLINICS_MAXIMUM = "#{UPPER_THE_NUMBER_OF_CLINICS_RANGE}#{NUMBER_OF_CLINICS_UNIT}#{OR_MORE}"

  # def str_number_of_clinics
  #   return "" if self.number_of_clinics.nil?
  #   if self.number_of_clinics == NUMBER_OF_CLINICS_MAXIMUM
  #     STR_NUMBER_OF_CLINICS_MAXIMUM
  #   elsif self.number_of_clinics >= 1 || self.number_of_clinics <= NUMBER_OF_CLINICS_RANGE
  #     "#{self.number_of_clinics} #{NUMBER_OF_CLINICS_UNIT}"
  #   else
  #     raise
  #   end
  # end

  # def self.make_select_options_number_of_clinics
  #   hash = {}
  #   (1..NUMBER_OF_CLINICS_RANGE).each do |i|
  #     hash["#{i}#{NUMBER_OF_CLINICS_UNIT}"] = i
  #   end
  #   hash[STR_NUMBER_OF_CLINICS_MAXIMUM] = STR_NUMBER_OF_CLINICS_MAXIMUM
  #   hash
  # end


  # number_of_aihの区分値(実施人工授精実施回数/CL単位)
  HASH_NUMBER_OF_AIH = {
    1 => "1回",
    2 => "2回",
    3 => "3回",
    4 => "4回",
    5 => "5回",
    6 => "6回",
    7 => "7回",
    8 => "8回",
    9 => "9回",
    10 => "10回",
    99 => "11回以上",
    100 => "不明",
  }

  def str_number_of_aih
    return HASH_NUMBER_OF_AIH[self.number_of_aih]
  end
  # NUMBER_OF_AIH_MAXIMUM = 1000
  # NUMBER_OF_AIH_RANGE = 10
  # UPPER_THE_NUMBER_OF_AIH_RANGE = NUMBER_OF_AIH_RANGE + 1
  # STR_NUMBER_OF_AIH_MAXIMUM = "#{UPPER_THE_NUMBER_OF_AIH_RANGE}#{TIMES}#{OR_MORE}"

  # def str_number_of_aih
  #   return "" if self.number_of_aih.nil?
  #   if self.number_of_aih == NUMBER_OF_AIH_MAXIMUM
  #     STR_NUMBER_OF_AIH_MAXIMUM
  #   elsif self.number_of_aih >= 1 || self.number_of_aih <= NUMBER_OF_AIH_RANGE
  #     "#{self.number_of_aih} #{TIMES}"
  #   else
  #     raise
  #   end
  # end

  # def self.make_select_options_number_of_aih
  #   hash = {}
  #   (1..NUMBER_OF_AIH_RANGE).each do |i|
  #     hash["#{i}#{TIMES}"] = i
  #   end
  #   hash[STR_NUMBER_OF_AIH_MAXIMUM] = STR_NUMBER_OF_AIH_MAXIMUM
  #   hash
  # end


  # first_age_to_startの区分値(治療開始年齢/妊活〜不妊治療全体)
  HASH_FIRST_AGE_TO_START = {
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

  def str_first_age_to_start
    return HASH_FIRST_AGE_TO_START[self.first_age_to_start]
  end
  # FIRST_AGE_TO_START_MAXIMUM = 1000
  # FIRST_AGE_TO_START_RANGE = 59
  # UPPER_THE_FIRST_AGE_TO_START_RANGE = FIRST_AGE_TO_START_RANGE + 1
  # STR_FIRST_AGE_TO_START_MAXIMUM = "#{UPPER_THE_FIRST_AGE_TO_START_RANGE}#{AGE}#{OR_MORE}"
  # STR_FIRST_AGE_TO_START_MINIMUM = "#{THE_BEGINNING_OF_AGE}#{AGE}#{OR_LESS}"

  # def str_first_age_to_start
  #   return "" if self.first_age_to_start.nil?
  #   if self.first_age_to_start == FIRST_AGE_TO_START_MAXIMUM
  #     STR_FIRST_AGE_TO_START_MAXIMUM
  #   elsif self.first_age_to_start <= THE_BEGINNING_OF_AGE
  #     STR_FIRST_AGE_TO_START_MINIMUM
  #   elsif self.first_age_to_start > THE_BEGINNING_OF_AGE || self.first_age_to_start <= FIRST_AGE_TO_START_RANGE
  #     "#{self.first_age_to_start} #{AGE}"
  #   else
  #     raise
  #   end
  # end
  
  # def self.make_select_options_first_age_to_start
  #   hash = {}
  #   (THE_BEGINNING_OF_AGE..FIRST_AGE_TO_START_RANGE).each do |i|
  #     if i == THE_BEGINNING_OF_AGE
  #       hash[STR_FIRST_AGE_TO_START_MINIMUM] = i
  #     else
  #       hash["#{i}#{AGE}"] = i
  #     end
  #   end
  #   hash[STR_FIRST_AGE_TO_START_MAXIMUM] = STR_FIRST_AGE_TO_START_MAXIMUM
  #   hash
  # end


  # treatment_start_ageの区分値(治療開始年齢/CL単位)
  HASH_TREATMENT_START_AGE = {
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

  def str_treatment_start_age
    return HASH_TREATMENT_START_AGE[self.treatment_start_age]
  end
  # TREATMENT_START_AGE_MAXIMUM = 1000
  # TREATMENT_START_AGE_RANGE = 59
  # UPPER_THE_TREATMENT_START_AGE_RANGE = TREATMENT_START_AGE_RANGE + 1
  # STR_TREATMENT_START_AGE_MAXIMUM = "#{UPPER_THE_TREATMENT_START_AGE_RANGE}#{AGE}#{OR_MORE}"
  # STR_TREATMENT_START_AGE_MINIMUM = "#{THE_BEGINNING_OF_AGE}#{AGE}#{OR_LESS}"

  # def str_treatment_start_age
  #   return "" if self.treatment_start_age.nil?
  #   if self.treatment_start_age == TREATMENT_START_AGE_MAXIMUM
  #     STR_TREATMENT_START_AGE_MAXIMUM
  #   elsif self.treatment_start_age <= THE_BEGINNING_OF_AGE
  #     STR_TREATMENT_START_AGE_MINIMUM
  #   elsif self.treatment_start_age > THE_BEGINNING_OF_AGE || self.treatment_start_age <= TREATMENT_START_AGE_RANGE
  #     "#{self.treatment_start_age} #{AGE}"
  #   else
  #     raise
  #   end
  # end
  
  # def self.make_select_options_treatment_start_age
  #   hash = {}
  #   (THE_BEGINNING_OF_AGE..TREATMENT_START_AGE_RANGE).each do |i|
  #     if i == THE_BEGINNING_OF_AGE
  #       hash[STR_TREATMENT_START_AGE_MINIMUM] = i
  #     else
  #       hash["#{i}#{AGE}"] = i
  #     end
  #   end
  #   hash[STR_TREATMENT_START_AGE_MAXIMUM] = STR_TREATMENT_START_AGE_MAXIMUM
  #   hash
  # end

  # treatment_end_ageの区分値(治療終了年齢/CL単位)
  HASH_TREATMENT_END_AGE = {
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

  def str_treatment_end_age
    return HASH_TREATMENT_END_AGE[self.treatment_end_age]
  end
  # TREATMENT_END_AGE_MAXIMUM = 1000
  # TREATMENT_END_AGE_RANGE = 59
  # UPPER_THE_TREATMENT_END_AGE_RANGE = TREATMENT_END_AGE_RANGE + 1
  # STR_TREATMENT_END_AGE_MAXIMUM = "#{UPPER_THE_TREATMENT_END_AGE_RANGE}#{AGE}#{OR_MORE}"
  # STR_TREATMENT_END_AGE_MINIMUM = "#{THE_BEGINNING_OF_AGE}#{AGE}#{OR_LESS}"


  # def str_treatment_end_age
  #   return "" if self.treatment_end_age.nil?
  #   if self.treatment_end_age == TREATMENT_END_AGE_MAXIMUM
  #     STR_TREATMENT_END_AGE_MAXIMUM
  #   elsif self.treatment_end_age <= THE_BEGINNING_OF_AGE
  #     STR_TREATMENT_END_AGE_MINIMUM
  #   elsif self.treatment_end_age > THE_BEGINNING_OF_AGE || self.treatment_end_age <= TREATMENT_END_AGE_RANGE
  #     "#{self.treatment_end_age} #{AGE}"
  #   else
  #     raise
  #   end
  # end
  
  # def self.make_select_options_treatment_end_age
  #   hash = {}
  #   (THE_BEGINNING_OF_AGE..TREATMENT_END_AGE_RANGE).each do |i|
  #     if i == THE_BEGINNING_OF_AGE
  #       hash[STR_TREATMENT_END_AGE_MINIMUM] = i
  #     else
  #       hash["#{i}#{AGE}"] = i
  #     end
  #   end
  #   hash[STR_TREATMENT_END_AGE_MAXIMUM] = STR_TREATMENT_END_AGE_MAXIMUM
  #   hash
  # end

  # age_of_partner_at_end_of_treatmentの区分値(治療終了時のパートナーの年齢/CL単位)
  HASH_AGE_OF_PARTNER_AT_END_OF_TREATMENT = {
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

  def str_age_of_partner_at_end_of_treatment
    return HASH_AGE_OF_PARTNER_AT_END_OF_TREATMENT[self.age_of_partner_at_end_of_treatment]
  end
  # AGE_OF_PARTNER_AT_END_OF_TREATMENT_MAXIMUM = 1000
  # AGE_OF_PARTNER_AT_END_OF_TREATMENT_RANGE = 59
  # UPPER_THE_AGE_OF_PARTNER_AT_END_OF_TREATMENT_RANGE = AGE_OF_PARTNER_AT_END_OF_TREATMENT_RANGE + 1
  # STR_AGE_OF_PARTNER_AT_END_OF_TREATMENT_MAXIMUM = "#{UPPER_THE_AGE_OF_PARTNER_AT_END_OF_TREATMENT_RANGE}#{AGE}#{OR_MORE}"
  # STR_AGE_OF_PARTNER_AT_END_OF_TREATMENT_MINIMUM = "#{THE_BEGINNING_OF_AGE}#{AGE}#{OR_LESS}"


  # def str_age_of_partner_at_end_of_treatment
  #   return "" if self.age_of_partner_at_end_of_treatment.nil?
  #   if self.age_of_partner_at_end_of_treatment == AGE_OF_PARTNER_AT_END_OF_TREATMENT_MAXIMUM
  #     STR_AGE_OF_PARTNER_AT_END_OF_TREATMENT_MAXIMUM
  #   elsif self.age_of_partner_at_end_of_treatment <= THE_BEGINNING_OF_AGE
  #     STR_AGE_OF_PARTNER_AT_END_OF_TREATMENT_MINIMUM
  #   elsif self.age_of_partner_at_end_of_treatment > THE_BEGINNING_OF_AGE || self.age_of_partner_at_end_of_treatment <= AGE_OF_PARTNER_AT_END_OF_TREATMENT_RANGE
  #     "#{self.age_of_partner_at_end_of_treatment} #{AGE}"
  #   else
  #     raise
  #   end
  # end
  
  # def self.make_select_options_age_of_partner_at_end_of_treatment
  #   hash = {}
  #   (THE_BEGINNING_OF_AGE..AGE_OF_PARTNER_AT_END_OF_TREATMENT_RANGE).each do |i|
  #     if i == THE_BEGINNING_OF_AGE
  #       hash[STR_AGE_OF_PARTNER_AT_END_OF_TREATMENT_MINIMUM] = i
  #     else
  #       hash["#{i}#{AGE}"] = i
  #     end
  #   end
  #   hash[STR_AGE_OF_PARTNER_AT_END_OF_TREATMENT_MAXIMUM] = STR_AGE_OF_PARTNER_AT_END_OF_TREATMENT_MAXIMUM
  #   hash
  # end

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

  def str_sairan_age
    return HASH_SAIRAN_AGE[self.sairan_age]
  end

  # ishoku_ageの区分値(移植時の年齢)
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

  def str_ishoku_age
    return HASH_ISHOKU_AGE[self.ishoku_age]
  end

  # total_number_of_sairanの区分値(全採卵回数/CL単位)
  HASH_TOTAL_NUMBER_OF_SAIRAN = {
    1 => "1回",
    2 => "2回",
    3 => "3回",
    4 => "4回",
    5 => "5回",
    6 => "6回",
    7 => "7回",
    8 => "8回",
    9 => "9回",
    10 => "10回",
    11 => "11回",
    12 => "12回",
    13 => "13回",
    14 => "14回",
    15 => "15回",
    16 => "16回",
    17 => "17回",
    18 => "18回",
    19 => "19回",
    20 => "20回",
    99 => "それ以上",
    100 => "不明",
  }

  def str_total_number_of_sairan
    return HASH_TOTAL_NUMBER_OF_SAIRAN[self.total_number_of_sairan]
  end
  # TOTAL_NUMBER_OF_SAIRAN_MAXIMUM = 1000
  # TOTAL_NUMBER_OF_SAIRAN_RANGE = 20
  # UPPER_THE_TOTAL_NUMBER_OF_SAIRAN_RANGE = TOTAL_NUMBER_OF_SAIRAN_RANGE + 1
  # STR_TOTAL_NUMBER_OF_SAIRAN_MAXIMUM = "#{UPPER_THE_TOTAL_NUMBER_OF_SAIRAN_RANGE}#{TIMES}#{OR_MORE}"

  # def str_total_number_of_sairan
  #   return "" if self.total_number_of_sairan.nil?
  #   if self.total_number_of_sairan == TOTAL_NUMBER_OF_SAIRAN_MAXIMUM
  #     STR_TOTAL_NUMBER_OF_SAIRAN_MAXIMUM
  #   elsif self.total_number_of_sairan >= 1 || self.total_number_of_sairan <= TOTAL_NUMBER_OF_SAIRAN_RANGE
  #     "#{self.total_number_of_sairan} #{TIMES}"
  #   else
  #     raise
  #   end
  # end

  # def self.make_select_options_total_number_of_sairan
  #   hash = {}
  #   (1..TOTAL_NUMBER_OF_SAIRAN_RANGE).each do |i|
  #     hash["#{i}#{TIMES}"] = i
  #   end

  #   hash[STR_TOTAL_NUMBER_OF_SAIRAN_MAXIMUM] = STR_TOTAL_NUMBER_OF_SAIRAN_MAXIMUM
  #   hash
  # end


  # all_number_of_sairanの区分値(全採卵回数/CL単位)
  HASH_ALL_NUMBER_OF_SAIRAN = {
    1 => "1回",
    2 => "2回",
    3 => "3回",
    4 => "4回",
    5 => "5回",
    6 => "6回",
    7 => "7回",
    8 => "8回",
    9 => "9回",
    10 => "10回",
    11 => "11回",
    12 => "12回",
    13 => "13回",
    14 => "14回",
    15 => "15回",
    16 => "16回",
    17 => "17回",
    18 => "18回",
    19 => "19回",
    20 => "20回",
    99 => "それ以上",
    100 => "不明",
  }

  def str_all_number_of_sairan
    return HASH_ALL_NUMBER_OF_SAIRAN[self.all_number_of_sairan]
  end

  # ALL_NUMBER_OF_SAIRAN_MAXIMUM = 1000
  # ALL_NUMBER_OF_SAIRAN_RANGE = 20
  # UPPER_THE_ALL_NUMBER_OF_SAIRAN_RANGE = ALL_NUMBER_OF_SAIRAN_RANGE + 1
  # STR_ALL_NUMBER_OF_SAIRAN_MAXIMUM = "#{UPPER_THE_ALL_NUMBER_OF_SAIRAN_RANGE}#{TIMES}#{OR_MORE}"

  # def str_all_number_of_sairan
  #   return "" if self.all_number_of_sairan.nil?
  #   if self.all_number_of_sairan == ALL_NUMBER_OF_SAIRAN_MAXIMUM
  #     STR_ALL_NUMBER_OF_SAIRAN_MAXIMUM
  #   elsif self.all_number_of_sairan >= 1 || self.all_number_of_sairan <= ALL_NUMBER_OF_SAIRAN_RANGE
  #     "#{self.all_number_of_sairan} #{TIMES}"
  #   else
  #     raise
  #   end
  # end

  # def self.make_select_options_all_number_of_sairan
  #   hash = {}
  #   (1..ALL_NUMBER_OF_SAIRAN_RANGE).each do |i|
  #     hash["#{i}#{TIMES}"] = i
  #   end

  #   hash[STR_ALL_NUMBER_OF_SAIRAN_MAXIMUM] = STR_ALL_NUMBER_OF_SAIRAN_MAXIMUM
  #   hash
  # end


  # total_number_of_transplantsの区分値(全移植回数/CL単位)
  HASH_TOTAL_NUMBER_OF_TRANSPLANTS = {
    1 => "1回",
    2 => "2回",
    3 => "3回",
    4 => "4回",
    5 => "5回",
    6 => "6回",
    7 => "7回",
    8 => "8回",
    9 => "9回",
    10 => "10回",
    11 => "11回",
    12 => "12回",
    13 => "13回",
    14 => "14回",
    15 => "15回",
    16 => "16回",
    17 => "17回",
    18 => "18回",
    19 => "19回",
    20 => "20回",
    99 => "それ以上",
    100 => "不明",
  }

  def str_total_number_of_transplants
    return HASH_TOTAL_NUMBER_OF_TRANSPLANTS[self.total_number_of_transplants]
  end
  # TOTAL_NUMBER_OF_TRANSPLANTS_MAXIMUM = 1000
  # TOTAL_NUMBER_OF_TRANSPLANTS_RANGE = 20
  # UPPER_THE_TOTAL_NUMBER_OF_TRANSPLANTS_RANGE = TOTAL_NUMBER_OF_TRANSPLANTS_RANGE + 1
  # STR_TOTAL_NUMBER_OF_TRANSPLANTS_MAXIMUM = "#{UPPER_THE_TOTAL_NUMBER_OF_TRANSPLANTS_RANGE}#{TIMES}#{OR_MORE}"

  # def str_total_number_of_transplants
  #   return "" if self.total_number_of_transplants.nil?
  #   if self.total_number_of_transplants == TOTAL_NUMBER_OF_TRANSPLANTS_MAXIMUM
  #     STR_TOTAL_NUMBER_OF_TRANSPLANTS_MAXIMUM
  #   elsif self.total_number_of_transplants >= 1 || self.total_number_of_transplants <= TOTAL_NUMBER_OF_TRANSPLANTS_RANGE
  #     "#{self.total_number_of_transplants} #{TIMES}"
  #   else
  #     raise
  #   end
  # end

  # def self.make_select_options_total_number_of_transplants
  #   hash = {}
  #   (1..TOTAL_NUMBER_OF_TRANSPLANTS_RANGE).each do |i|
  #     hash["#{i}#{TIMES}"] = i
  #   end
  #   hash[STR_TOTAL_NUMBER_OF_TRANSPLANTS_MAXIMUM] = STR_TOTAL_NUMBER_OF_TRANSPLANTS_MAXIMUM
  #   hash
  # end

  # total_number_of_eggs_transplantedの区分値(全移植個数/CL単位)
  HASH_TOTAL_NUMBER_OF_EGGS_TRANSPLANTED = {
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
    99 => "それ以上",
    100 => "不明",
  }

  def str_total_number_of_eggs_transplanted
    return HASH_TOTAL_NUMBER_OF_EGGS_TRANSPLANTED[self.total_number_of_eggs_transplanted]
  end
  # TOTAL_NUMBER_OF_EGGS_TRANSPLANTED_MAXIMUM = 1000
  # TOTAL_NUMBER_OF_EGGS_TRANSPLANTED_RANGE = 20
  # UPPER_THE_TOTAL_NUMBER_OF_EGGS_TRANSPLANTED_RANGE = TOTAL_NUMBER_OF_EGGS_TRANSPLANTED_RANGE + 1
  # STR_TOTAL_NUMBER_OF_EGGS_TRANSPLANTED_MAXIMUM = "#{UPPER_THE_TOTAL_NUMBER_OF_EGGS_TRANSPLANTED_RANGE}#{PIECES}"

  # def str_total_number_of_eggs_transplanted
  #   return "" if self.total_number_of_eggs_transplanted.nil?
  #   if self.total_number_of_eggs_transplanted == TOTAL_NUMBER_OF_EGGS_TRANSPLANTED_MAXIMUM
  #     STR_TOTAL_NUMBER_OF_EGGS_TRANSPLANTED_MAXIMUM
  #   elsif self.total_number_of_eggs_transplanted >= 1 || self.total_number_of_eggs_transplanted <= TOTAL_NUMBER_OF_EGGS_TRANSPLANTED_RANGE
  #     "#{self.total_number_of_eggs_transplanted} #{PIECES}"
  #   else
  #     raise
  #   end
  # end

  # def self.make_select_options_total_number_of_eggs_transplanted
  #   hash = {}
  #   (1..TOTAL_NUMBER_OF_EGGS_TRANSPLANTED_RANGE).each do |i|
  #     hash["#{i}#{PIECES}"] = i
  #   end
  #   hash[STR_TOTAL_NUMBER_OF_EGGS_TRANSPLANTED_MAXIMUM] = STR_TOTAL_NUMBER_OF_EGGS_TRANSPLANTED_MAXIMUM
  #   hash
  # end


  # all_number_of_transplantsの区分値(全移植回数/CL単位)
  HASH_ALL_NUMBER_OF_TRANSPLANTS = {
    1 => "1回",
    2 => "2回",
    3 => "3回",
    4 => "4回",
    5 => "5回",
    6 => "6回",
    7 => "7回",
    8 => "8回",
    9 => "9回",
    10 => "10回",
    11 => "11回",
    12 => "12回",
    13 => "13回",
    14 => "14回",
    15 => "15回",
    16 => "16回",
    17 => "17回",
    18 => "18回",
    19 => "19回",
    20 => "20回",
    99 => "それ以上",
    100 => "不明",
  }

  def str_all_number_of_transplants
    return HASH_ALL_NUMBER_OF_TRANSPLANTS[self.all_number_of_transplants]
  end
  # ALL_NUMBER_OF_TRANSPLANTS_MAXIMUM = 1000
  # ALL_NUMBER_OF_TRANSPLANTS_RANGE = 20
  # UPPER_THE_ALL_NUMBER_OF_TRANSPLANTS_RANGE = ALL_NUMBER_OF_TRANSPLANTS_RANGE + 1
  # STR_ALL_NUMBER_OF_TRANSPLANTS_MAXIMUM = "#{UPPER_THE_ALL_NUMBER_OF_TRANSPLANTS_RANGE}#{TIMES}#{OR_MORE}"

  # def str_all_number_of_transplants
  #   return "" if self.all_number_of_transplants.nil?
  #   if self.all_number_of_transplants == ALL_NUMBER_OF_TRANSPLANTS_MAXIMUM
  #     STR_ALL_NUMBER_OF_TRANSPLANTS_MAXIMUM
  #   elsif self.all_number_of_transplants >= 1 || self.all_number_of_transplants <= ALL_NUMBER_OF_TRANSPLANTS_RANGE
  #     "#{self.all_number_of_transplants} #{TIMES}"
  #   else
  #     raise
  #   end
  # end

  # def self.make_select_options_all_number_of_transplants
  #   hash = {}
  #   (1..ALL_NUMBER_OF_TRANSPLANTS_RANGE).each do |i|
  #     hash["#{i}#{TIMES}"] = i
  #   end
  #   hash[STR_ALL_NUMBER_OF_TRANSPLANTS_MAXIMUM] = STR_ALL_NUMBER_OF_TRANSPLANTS_MAXIMUM
  #   hash
  # end


  # number_of_eggs_collectedの区分値(採卵個数/CL単位)
  HASH_NUMBER_OF_EGGS_COLLECTED = {
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

  def str_number_of_eggs_collected
    return HASH_NUMBER_OF_EGGS_COLLECTED[self.number_of_eggs_collected]
  end
  # NUMBER_OF_EGGS_COLLECTED_MAXIMUM = 1000
  # NUMBER_OF_EGGS_COLLECTED_RANGE1 = 100
  # NUMBER_OF_EGGS_COLLECTED_RANGE2 = 106
  # STR_NUMBER_OF_EGGS_COLLECTED_MAXIMUM = "1,000#{PIECES}#{OR_MORE}"

  # def str_number_of_eggs_collected
  #   return "" if self.number_of_eggs_collected.nil?
  #   case self.number_of_eggs_collected
  #   when UNKNOWN
  #     STR_UNKNOWN
  #   when NUMBER_OF_EGGS_COLLECTED_MAXIMUM
  #     STR_NUMBER_OF_EGGS_COLLECTED_MAXIMUM
  #   when 1..NUMBER_OF_EGGS_COLLECTED_RANGE1
  #     "#{self.number_of_eggs_collected} #{PIECES}"
  #   when NUMBER_OF_EGGS_COLLECTED_RANGE1 + 1
  #     "101〜150#{PIECES}"
  #   when NUMBER_OF_EGGS_COLLECTED_RANGE1 + 2
  #     "151〜200#{PIECES}"
  #   when NUMBER_OF_EGGS_COLLECTED_RANGE1 + 3
  #     "201〜300#{PIECES}"
  #   when NUMBER_OF_EGGS_COLLECTED_RANGE1 + 4
  #     "301〜400#{PIECES}"
  #   when NUMBER_OF_EGGS_COLLECTED_RANGE1 + 5
  #     "401〜500#{PIECES}"
  #   when NUMBER_OF_EGGS_COLLECTED_RANGE1 + 6
  #     "501〜999#{PIECES}"
  #   else
  #     raise
  #   end
  # end

  # def self.make_select_options_number_of_eggs_collected
  #   hash = {}
  #   (1..NUMBER_OF_EGGS_COLLECTED_RANGE1).each do |i|
  #     hash["#{i}#{PIECES}"] = i
  #   end
  #   hash["101〜150#{PIECES}"] = "101〜150#{PIECES}"
  #   hash["151〜200#{PIECES}"] = "101〜150#{PIECES}"
  #   hash["201〜300#{PIECES}"] = "101〜150#{PIECES}"
  #   hash["301〜400#{PIECES}"] = "101〜150#{PIECES}"
  #   hash["401〜500#{PIECES}"] = "101〜150#{PIECES}"
  #   hash["501〜1,000#{PIECES}"] = "101〜150#{PIECES}"
  #   hash[STR_NUMBER_OF_EGGS_COLLECTED_MAXIMUM] = STR_NUMBER_OF_EGGS_COLLECTED_MAXIMUM
  #   hash[STR_UNKNOWN] = STR_UNKNOWN
  #   hash
  # end


  # number_of_fertilized_eggsの区分値(最新採卵周期での受精した個数/CL単位)
  HASH_NUMBER_OF_FERTILIZED_EGGS = {
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

  def str_number_of_fertilized_eggs
    return HASH_NUMBER_OF_FERTILIZED_EGGS[self.number_of_fertilized_eggs]
  end
  # NUMBER_OF_FERTILIZED_EGGS_MAXIMUM = 1000
  # NUMBER_OF_FERTILIZED_EGGS_RANGE = 50
  # STR_NUMBER_OF_FERTILIZED_EGGS_MAXIMUM = "それ#{OR_MORE}"

  # def str_number_of_fertilized_eggs
  #   return "" if self.number_of_fertilized_eggs.nil?
  #   if self.number_of_fertilized_eggs == NUMBER_OF_FERTILIZED_EGGS_MAXIMUM
  #     STR_NUMBER_OF_FERTILIZED_EGGS_MAXIMUM
  #   elsif self.number_of_fertilized_eggs >= 1 || self.number_of_fertilized_eggs <= NUMBER_OF_FERTILIZED_EGGS_RANGE
  #     "#{self.number_of_fertilized_eggs} #{PIECES}"
  #   else
  #     raise
  #   end
  # end

  # def self.make_select_options_number_of_fertilized_eggs
  #   hash = {}
  #   (1..NUMBER_OF_FERTILIZED_EGGS_RANGE).each do |i|
  #     hash["#{i}#{PIECES}"] = i
  #   end
  #   hash[STR_NUMBER_OF_FERTILIZED_EGGS_MAXIMUM] = STR_NUMBER_OF_FERTILIZED_EGGS_MAXIMUM
  #   hash[STR_UNKNOWN] = STR_UNKNOWN
  #   hash
  # end


  # number_of_transferable_embryosの区分値(最新採卵周期での受精した個数/CL単位)
  HASH_NUMBER_OF_TRANSFERABLE_EMBRYOS = {
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

  def str_number_of_transferable_embryos
    return HASH_NUMBER_OF_TRANSFERABLE_EMBRYOS[self.number_of_transferable_embryos]
  end
  # NUMBER_OF_TRANSFERABLE_EMBRYOS_MAXIMUM = 1000
  # NUMBER_OF_TRANSFERABLE_EMBRYOS_RANGE = 50
  # STR_NUMBER_OF_TRANSFERABLE_EMBRYOS_MAXIMUM = "それ#{OR_MORE}"

  # def str_number_of_transferable_embryos
  #   return "" if self.number_of_transferable_embryos.nil?
  #   if self.number_of_transferable_embryos == NUMBER_OF_TRANSFERABLE_EMBRYOS_MAXIMUM
  #     STR_NUMBER_OF_TRANSFERABLE_EMBRYOS_MAXIMUM
  #   elsif self.number_of_transferable_embryos >= 1 || self.number_of_transferable_embryos <= NUMBER_OF_TRANSFERABLE_EMBRYOS_RANGE
  #     "#{self.number_of_transferable_embryos} #{PIECES}"
  #   else
  #     raise
  #   end
  # end

  # def self.make_select_options_number_of_transferable_embryos
  #   hash = {}
  #   (1..NUMBER_OF_TRANSFERABLE_EMBRYOS_RANGE).each do |i|
  #     hash["#{i}#{PIECES}"] = i
  #   end
  #   hash[STR_NUMBER_OF_TRANSFERABLE_EMBRYOS_MAXIMUM] = STR_NUMBER_OF_TRANSFERABLE_EMBRYOS_MAXIMUM
  #   hash[STR_UNKNOWN] = STR_UNKNOWN
  #   hash
  # end


  # number_of_frozen_eggsの区分値(最新周期での凍結できた数/CL単位)
  HASH_NUMBER_OF_FROZEN_EGGS = {
    0 => "0個",
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

  def str_number_of_frozen_eggs
    return HASH_NUMBER_OF_FROZEN_EGGS[self.number_of_frozen_eggs]
  end
  # NUMBER_OF_FROZEN_EGGS_MAXIMUM = 1000
  # NUMBER_OF_FROZEN_EGGS_RANGE = 50
  # STR_NUMBER_OF_FROZEN_EGGS_MAXIMUM = "それ#{OR_MORE}"

  # def str_number_of_frozen_eggs
  #   return "" if self.number_of_frozen_eggs.nil?
  #   if self.number_of_frozen_eggs == NUMBER_OF_FROZEN_EGGS_MAXIMUM
  #     STR_NUMBER_OF_FROZEN_EGGS_MAXIMUM
  #   elsif self.number_of_frozen_eggs >= 1 || self.number_of_frozen_eggs <= NUMBER_OF_FROZEN_EGGS_RANGE
  #     "#{self.number_of_frozen_eggs} #{PIECES}"
  #   else
  #     raise
  #   end
  # end

  # def self.make_select_options_number_of_frozen_eggs
  #   hash = {}
  #   (0..NUMBER_OF_FROZEN_EGGS_RANGE).each do |i|
  #     hash["#{i}#{PIECES}"] = i
  #   end
  #   hash[STR_NUMBER_OF_FROZEN_EGGS_MAXIMUM] = STR_NUMBER_OF_FROZEN_EGGS_MAXIMUM
  #   hash[STR_UNKNOWN] = STR_UNKNOWN
  #   hash
  # end


  # number_of_eggs_storedの区分値(凍結胚の在庫数/CL単位)
  HASH_NUMBER_OF_EGGS_STORED = {
    0 => "0個",
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

  def str_number_of_eggs_stored
    return HASH_NUMBER_OF_EGGS_STORED[self.number_of_eggs_stored]
  end
  # NUMBER_OF_EGGS_STORED_MAXIMUM = 1000
  # NUMBER_OF_EGGS_STORED_RANGE = 50
  # STR_NUMBER_OF_EGGS_STORED_MAXIMUM = "それ#{OR_MORE}"

  # def str_number_of_eggs_stored
  #   return "" if self.number_of_eggs_stored.nil?
  #   if self.number_of_eggs_stored == NUMBER_OF_EGGS_STORED_MAXIMUM
  #     STR_NUMBER_OF_EGGS_STORED_MAXIMUM
  #   elsif self.number_of_eggs_stored >= 1 || self.number_of_eggs_stored <= NUMBER_OF_EGGS_STORED_RANGE
  #     "#{self.number_of_eggs_stored} #{PIECES}"
  #   else
  #     raise
  #   end
  # end

  # def self.make_select_options_number_of_eggs_stored
  #   hash = {}
  #   (0..NUMBER_OF_EGGS_STORED_RANGE).each do |i|
  #     hash["#{i}#{PIECES}"] = i
  #   end
  #   hash[STR_NUMBER_OF_EGGS_STORED_MAXIMUM] = STR_NUMBER_OF_EGGS_STORED_MAXIMUM
  #   hash[STR_UNKNOWN] = STR_UNKNOWN
  #   hash
  # end


  # embryo_culture_daysの区分値(妊娠に至った胚の培養日数)
  HASH_EMBRYO_CULTURE_DAYS = {
    1 => "1日目",
    2 => "2日目",
    3 => "3日目",
    4 => "4日目",
    5 => "5日目",
    6 => "6日目",
    7 => "7日目",
    8 => "8日目",
    9 => "9日目",
    10 => "10日目",
    99 => "それ以上",
    100 => "不明",
  }

  def str_embryo_culture_days
    return HASH_EMBRYO_CULTURE_DAYS[self.embryo_culture_days]
  end
  # EMBRYO_CULTURE_DAYS_MAXIMUM = 1000
  # EMBRYO_CULTURE_DAYS_RANGE = 10
  # STR_EMBRYO_CULTURE_DAYS_MAXIMUM = "それ#{DAY}#{OR_MORE}"

  # def str_embryo_culture_days
  #   return "" if self.embryo_culture_days.nil?
  #   case self.embryo_culture_days
  #   when UNKNOWN
  #     STR_UNKNOWN
  #   when EMBRYO_CULTURE_DAYS_MAXIMUM
  #     STR_EMBRYO_CULTURE_DAYS_MAXIMUM
  #   when 1..EMBRYO_CULTURE_DAYS_RANGE
  #     "#{self.embryo_culture_days} #{DAY}"
  #   else
  #     raise
  #   end
  # end

  # def self.make_select_options_embryo_culture_days
  #   hash = {}
  #   (1..EMBRYO_CULTURE_DAYS_RANGE).each do |i|
  #     hash["#{i}#{DAY}"] = i
  #   end
  #   hash[STR_EMBRYO_CULTURE_DAYS_MAXIMUM] = STR_EMBRYO_CULTURE_DAYS_MAXIMUM
  #   hash[STR_UNKNOWN] = STR_UNKNOWN
  #   hash
  # end

end

# == Schema Information
#
# Table name: reports
#
#  id                                           :bigint           not null, primary key
#  about_causes_of_infertility                  :text
#  about_work_and_working_style                 :text
#  adoption                                     :integer
#  age_of_partner_at_end_of_treatment           :integer
#  all_cost                                     :integer
#  all_grant_amount                             :integer
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
#  briefing_session                             :integer
#  capital_size                                 :integer
#  capital_size_status                          :integer
#  city_at_the_time_status                      :integer          default("show"), not null
#  clinic_review                                :text
#  clinic_selection_criteria                    :integer
#  comfort_of_space                             :integer
#  content                                      :text
#  cost                                         :integer
#  credit_card_validity                         :integer
#  creditcards_can_be_used_from_more_than       :integer
#  current_state                                :integer
#  department                                   :integer
#  department_status                            :integer
#  description_of_eggs_and_sperm_used           :text
#  details_of_icsi                              :integer
#  doctor_quality                               :integer
#  domestic_or_foreign_capital                  :integer
#  domestic_or_foreign_capital_status           :integer
#  early_embryo_grade                           :integer
#  early_embryo_grade_supplementary_explanation :text
#  egg_maturity                                 :integer
#  embryo_culture_days                          :integer
#  embryo_stage                                 :integer
#  explanation_and_impression_about_ishoku      :text
#  explanation_and_impression_about_sairan      :text
#  explanation_of_cost                          :text
#  explanation_of_frozen_embryo_storage_cost    :text
#  fertility_treatment_number                   :integer
#  first_age_to_start                           :integer
#  frozen_embryo_storage_cost                   :integer
#  fuiku                                        :integer
#  fuiku_supplementary_explanation              :text
#  household_net_income                         :integer
#  household_net_income_status                  :integer          default("show"), not null
#  impression_of_price                          :integer
#  impression_of_technology                     :integer
#  industry_type                                :integer
#  industry_type_status                         :integer
#  inspection_supplementary_explanation         :text
#  ishoku_age                                   :integer
#  ishoku_cost                                  :integer
#  ishoku_cost_explanation                      :text
#  notes_on_type_of_sairan_cycle                :text
#  number_of_aih                                :integer
#  number_of_clinics                            :integer
#  number_of_eggs_collected                     :integer
#  number_of_eggs_stored                        :integer
#  number_of_employees                          :integer
#  number_of_employees_status                   :integer
#  number_of_fertilized_eggs                    :integer
#  number_of_frozen_eggs                        :integer
#  number_of_miscarriages                       :integer
#  number_of_stillbirths                        :integer
#  number_of_times_the_grant_was_received       :integer
#  number_of_transferable_embryos               :integer
#  online_consultation                          :integer
#  online_consultation_details                  :text
#  other_effort_cost                            :integer
#  other_effort_supplementary_explanation       :text
#  ova_with_ivm                                 :integer
#  period_of_time_spent_traveling               :integer
#  pgt1                                         :integer
#  pgt1_status                                  :integer
#  pgt2                                         :integer
#  pgt2_status                                  :integer
#  pgt_supplementary_explanation                :text
#  pgt_supplementary_explanation_status         :integer
#  position                                     :integer
#  position_status                              :integer
#  prefecture_at_the_time_status                :integer          default("show"), not null
#  private_or_listed_company                    :integer
#  private_or_listed_company_status             :integer
#  probability_of_normal_morphology_of_sperm    :float
#  reasons_for_choosing_this_clinic             :text
#  reservation_method                           :integer
#  sairan_age                                   :integer
#  sairan_cost                                  :integer
#  sairan_cost_explanation                      :text
#  selection_of_anesthesia_type                 :integer
#  semen_concentration                          :integer
#  semen_volume                                 :float
#  smoking                                      :integer
#  sperm_advance_rate                           :float
#  sperm_description                            :text
#  sperm_motility                               :float
#  staff_quality                                :integer
#  status                                       :integer          default("released"), not null
#  supplement_cost                              :integer
#  supplement_supplementary_explanation         :text
#  supplementary_explanation_of_grant           :text
#  suspended_or_retirement_job                  :integer
#  title                                        :string
#  total_amount_of_sperm                        :integer
#  total_number_of_eggs_transplanted            :integer
#  total_number_of_sairan                       :integer
#  total_number_of_transplants                  :integer
#  transplant_method                            :integer
#  treatment_end_age                            :integer
#  treatment_period                             :integer
#  treatment_start_age                          :integer
#  treatment_support_system                     :integer
#  type_of_ovarian_stimulation                  :integer
#  type_of_sairan_cycle                         :integer
#  types_of_eggs_and_sperm                      :integer
#  types_of_fertilization_methods               :integer
#  use_of_anesthesia                            :integer
#  work_style                                   :integer
#  work_style_status                            :integer
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
