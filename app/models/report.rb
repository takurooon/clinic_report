class Report < ApplicationRecord

  # レポートの公開状況 参考:https://qiita.com/tomoharutt/items/f1a70babaddcf7ab47be
  enum status: { released: 0, nonreleased: 1 }

  # 仕事セクションの(年収などの項目）公開状況 参考:https://qiita.com/emacs_hhkb/items/fce19f443e5770ad2e13
  enum work_style_status: { show: 0, hide: 1 }, _prefix: true
  enum industry_type_status: { show: 0, hide: 1 }, _prefix: true
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

  MAX_CONTENT_LENGTH = 100000
  MEGA_BYTES = 5
  ONE_KILOBYTE = 1024
  MAX_CONTENT_ATTACHMENT_BYTE_SIZE = MEGA_BYTES * 1_000 * ONE_KILOBYTE
  MAX_CONTENT_ATTACHMENTS_COUNT = 10

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

  require 'nokogiri'
  def summarize_content
    doc = Nokogiri::HTML::DocumentFragment.parse(self.content.to_s)
    summary_content = doc.xpath('div/div').text
    return summary_content
  end

  # アクションテキスト
  has_rich_text :content
  
  # ---親---
  belongs_to :user
  belongs_to :clinic
  belongs_to :prefecture
  belongs_to :city

  # ---子---
  has_many :comments, dependent: :destroy

  # いいね
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  # 通知モデル
  has_many :notifications, dependent: :destroy

  def create_notification_like!(current_user)
    # https://qiita.com/nekojoker/items/80448944ec9aaae48d0a
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and report_id = ? and action = ? ", current_user.id, user_id, id, 'like'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        report_id: id,
        visited_id: user_id,
        action: 'like'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

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

  # 転院遍歴
  has_many :itinerary_of_choosing_a_clinics, dependent: :destroy
  accepts_nested_attributes_for :itinerary_of_choosing_a_clinics, reject_if: :all_blank, allow_destroy: true, update_only: true
  def reject_itinerary_of_choosing_a_clinics(attributes)
    exists = attributes[:id].present?
    empty = attributes[:email].blank?
    attributes.merge!(_destroy: 1) if exists && empty
    !exists && empty
  end

  # 採卵日当日のホルモン
  has_many :day_of_sairans, inverse_of: :report, dependent: :destroy
  accepts_nested_attributes_for :day_of_sairans, reject_if: :all_blank, allow_destroy: true, update_only: true

  # 採卵周期のホルモン
  has_many :sairan_hormones, inverse_of: :report, dependent: :destroy
  accepts_nested_attributes_for :sairan_hormones, reject_if: :all_blank, allow_destroy: true, update_only: true

  # 不成功採卵周期の詳細
  has_many :unsuccessful_sairan_cycles, inverse_of: :report, dependent: :destroy
  accepts_nested_attributes_for :unsuccessful_sairan_cycles, reject_if: :all_blank, allow_destroy: true, update_only: true

  # 不成功移植周期の詳細
  has_many :unsuccessful_ishoku_cycles, inverse_of: :report, dependent: :destroy
  accepts_nested_attributes_for :unsuccessful_ishoku_cycles, reject_if: :all_blank, allow_destroy: true, update_only: true

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

  # 基本検査(女性)
  has_many :report_inspections, dependent: :destroy
  has_many :inspections, through: :report_inspections

  # 基本検査(男性)
  has_many :report_male_inspections, dependent: :destroy
  has_many :male_inspections, through: :report_male_inspections

  # レポコのクリニックでの基本検査(女性)
  has_many :report_cl_female_inspections, dependent: :destroy
  has_many :cl_female_inspections, through: :report_cl_female_inspections

  # レポコのクリニックでの基本検査(男性)
  has_many :report_cl_male_inspections, dependent: :destroy
  has_many :cl_male_inspections, through: :report_cl_male_inspections

  # コスト負担者
  has_many :report_cost_burdens, dependent: :destroy
  has_many :cost_burdens, through: :report_cost_burdens

  # 不育症の原因
  has_many :report_fuiku_inspections, dependent: :destroy
  has_many :fuiku_inspections, through: :report_fuiku_inspections

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

  # 採卵周期での使用薬剤
  has_many :report_sairan_medicines, dependent: :destroy
  has_many :sairan_medicines, through: :report_sairan_medicines

  # 移植周期での使用薬剤
  has_many :report_transfer_medicines, dependent: :destroy
  has_many :transfer_medicines, through: :report_transfer_medicines

  # 移植オプション
  has_many :report_transfer_options, dependent: :destroy
  has_many :transfer_options, through: :report_transfer_options

  # クリニックでの治療以外に行ったこと(女性)
  has_many :report_other_efforts, dependent: :destroy
  has_many :other_efforts, through: :report_other_efforts

  # クリニックでの治療以外に行ったこと(男性)
  has_many :report_m_other_efforts, dependent: :destroy
  has_many :m_other_efforts, through: :report_m_other_efforts

  # サプリ(女性)
  has_many :report_supplements, dependent: :destroy
  has_many :supplements, through: :report_supplements

  # サプリ(男性)
  has_many :report_m_supplements, dependent: :destroy
  has_many :m_supplements, through: :report_m_supplements

  # CL選定理由
  has_many :report_cl_selections, dependent: :destroy
  has_many :cl_selections, through: :report_cl_selections

  # 検索
  def self.search(search)
    if search
      where(['name LIKE ?', "%#{search}%"])
    else
      all
    end
  end

  # current_stateの区分値(現在の状況)
  HASH_CURRENT_STATE = {
    1 => "妊娠中",
    2 => "妊娠中（多胎）",
    3 => "出産済み",
    4 => "出産済み（多胎）",
    # 5 => "出産に至らず",
    # 6 => "転院した",
    # 7 => "お休み中",
    # 8 => "治療自体を完全にやめた",
    # 99 => "その他"
  }

  def str_current_state
    return HASH_CURRENT_STATE[self.current_state]
  end

  # 検索画面用のcurrent_stateの区分値(現在の状況)
  HASH_CURRENT_STATE_SEARCH = {
    1 => "妊娠中",
    2 => "妊娠中（多胎）",
    3 => "出産済み",
    4 => "出産済み（多胎）",
    # 5 => "出産に至らず",
    # 6 => "転院した",
    # 7 => "お休み中",
    # 8 => "治療自体を完全にやめた",
    # 99 => "その他"
  }

  def str_current_state_search
    return HASH_CURRENT_STATE_SEARCH[self.current_state]
  end

  # treatment_periodの区分値(休み期間除く正味治療期間/CL単位)
  HASH_TREATMENT_PERIOD = {
    100 => "不明",
    1 => "〜1ヵ月",
    2 => "〜2ヵ月",
    3 => "〜3ヵ月",
    4 => "〜4ヵ月",
    5 => "〜5ヵ月",
    6 => "〜6ヵ月",
    7 => "〜7ヵ月",
    8 => "〜8ヵ月",
    9 => "〜9ヵ月",
    10 => "〜10ヵ月",
    11 => "〜11ヵ月",
    12 => "〜1年",
    13 => "〜1年半",
    14 => "〜2年",
    15 => "〜2年半",
    16 => "〜3年",
    17 => "〜3年半",
    18 => "〜4年",
    19 => "〜4年半",
    20 => "〜5年",
    21 => "〜6年",
    22 => "〜7年",
    23 => "〜8年",
    24 => "〜9年",
    25 => "〜10年",
    99 => "それ以上",
  }

  def str_treatment_period
    return HASH_TREATMENT_PERIOD[self.treatment_period]
  end

  # rest_periodの区分値(休み期間/CL単位)
  HASH_REST_PERIOD = {
    0 => "なし",
    1 => "〜1ヵ月",
    2 => "〜2ヵ月",
    3 => "〜3ヶ月",
    4 => "〜4ヶ月",
    5 => "〜5ヶ月",
    6 => "〜半年",
    7 => "〜1半",
    8 => "〜2年",
    99 => "2年以上",
    100 => "不明",
  }

  def str_rest_period
    return HASH_REST_PERIOD[self.rest_period]
  end

  # how_long_to_continue_treatmentの区分値(治療継続期間設定の有無)
  HASH_HOW_LONG_TO_CONTINUE_TREATMENT = {
    1 => "決めていた",
    2 => "決めていなかった",
    99 => "その他",
    100 => "不明",
  }

  def str_how_long_to_continue_treatment
    return HASH_HOW_LONG_TO_CONTINUE_TREATMENT[self.how_long_to_continue_treatment]
  end

  # how_long_to_continue_treatment2の区分値(具体的な治療継続期間)
  HASH_HOW_LONG_TO_CONTINUE_TREATMENT2 = {
    1 => "〜3ヶ月",
    2 => "〜半年",
    3 => "〜1年",
    4 => "〜2年",
    5 => "〜3年",
    6 => "〜5年",
    7 => "それ以上",
    99 => "その他",
    100 => "不明",
  }

  def str_how_long_to_continue_treatment2
    return HASH_HOW_LONG_TO_CONTINUE_TREATMENT2[self.how_long_to_continue_treatment2]
  end

  # followup_investigationの区分地値(出産確認の連絡有無)
  HASH_FOLLOWUP_INVESTIGATION = {
    1 => "出産確認の書類が届いた",
    2 => "出産確認の電話がかかってきた",
    3 => "その他連絡手段で確認がきた",
    4 => "確認はなかった",
    99 => "その他",
    100 => "不明",
  }

  def str_followup_investigation
    return HASH_FOLLOWUP_INVESTIGATION[self.followup_investigation]
  end

  # amhの区分値(AMH値)
  HASH_AMH = {
    100 => "不明",
    1 => "0.1以下",
    2 => "0.2以下",
    3 => "0.3以下",
    4 => "0.4以下",
    5 => "0.5以下",
    6 => "0.6以下",
    7 => "0.7以下",
    8 => "0.8以下",
    9 => "0.9以下",
    10 => "1.0以下",
    11 => "1.5以下",
    12 => "2.0以下",
    13 => "2.5以下",
    14 => "3.0以下",
    15 => "3.5以下",
    16 => "4.0以下",
    17 => "4.5以下",
    18 => "5.0以下",
    19 => "5.5以下",
    20 => "6.0以下",
    21 => "6.5以下",
    22 => "7.0以下",
    23 => "7.5以下",
    24 => "8.0以下",
    25 => "8.5以下",
    26 => "9.0以下",
    27 => "9.5以下",
    28 => "10.0以下",
    99 => "それ以上",
  }

  def str_amh
    return HASH_AMH[self.amh]
  end

  # 検索画面用のamhの区分値(AMH値)
  HASH_AMH_SEARCH = {
    100 => "不明",
    1 => "0.1以下",
    2 => "0.2以下",
    3 => "0.3以下",
    4 => "0.4以下",
    5 => "0.5以下",
    6 => "0.6以下",
    7 => "0.7以下",
    8 => "0.8以下",
    9 => "0.9以下",
    10 => "1.0以下",
    11 => "1.5以下",
    12 => "2.0以下",
    13 => "2.5以下",
    14 => "3.0以下",
    15 => "3.5以下",
    16 => "4.0以下",
    17 => "4.5以下",
    18 => "5.0以下",
    19 => "5.5以下",
    20 => "6.0以下",
    21 => "6.5以下",
    22 => "7.0以下",
    23 => "7.5以下",
    24 => "8.0以下",
    25 => "8.5以下",
    26 => "9.0以下",
    27 => "9.5以下",
    28 => "10.0以下",
    99 => "それ以上",
  }

  def str_amh_search
    return HASH_AMH_SEARCH[self.amh]
  end

  # types_of_eggs_and_spermの区分値(卵子と精子の帰属)
  HASH_TYPES_OF_EGGS_AND_SPERM = {
    1 => "自分たちの卵子と精子",
    2 => "提供卵子",
    3 => "提供精子",
    99 => "その他",
  }

  def str_types_of_eggs_and_sperm
    return HASH_TYPES_OF_EGGS_AND_SPERM[self.types_of_eggs_and_sperm]
  end

  # types_of_eggs_and_sperm_statusの区分値(卵子と精子の状態)
  HASH_TYPES_OF_EGGS_AND_SPERM_STATUS = {
    1 => "未凍結卵子と未凍結精子",
    2 => "凍結卵子",
    3 => "凍結精子",
    4 => "凍結卵子と凍結精子",
    99 => "その他",
  }

  def str_types_of_eggs_and_sperm_status
    return HASH_TYPES_OF_EGGS_AND_SPERM_STATUS[self.types_of_eggs_and_sperm_status]
  end

  # self_injectionの区分値(自己注射の可否)
  HASH_SELF_INJECTION = {
    1 => "選択可(自己注射or院内注射)",
    2 => "選択不可(自己注射のみ)",
    3 => "選択不可(院内注射のみ)",
    99 => "その他",
    100 => "不明"
  }

  def str_self_injection
    return HASH_SELF_INJECTION[self.self_injection]
  end

  # number_of_injectionsの区分値(注射の回数)
  HASH_NUMBER_OF_INJECTIONS = {
    100 => "不明",
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
  }

  def str_number_of_injections
    return HASH_NUMBER_OF_INJECTIONS[self.number_of_injections]
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

  # choice_of_sairantimeの区分値(採卵の時間帯の選択余地)
  HASH_CHOICE_OF_SAIRANTIME = {
    1 => "午前のみ(選択の余地なし)",
    2 => "午後のみ(選択の余地なし)",
    3 => "午前･午後を選択できた",
    4 => "時間指定ができた",
    99 => "その他",
    100 => "不明"
  }

  def str_choice_of_sairantime
    return HASH_CHOICE_OF_SAIRANTIME[self.choice_of_sairantime]
  end

  # time_for_sairanの区分値(採卵の時間)
  HASH_TIME_FOR_SAIRAN = {
    1 => "6時台",
    2 => "7時台",
    3 => "8時台",
    4 => "9時台",
    5 => "10時台",
    6 => "11時台",
    7 => "12時台",
    8 => "13時台",
    9 => "14時台",
    10 => "15時台",
    11 => "16時台",
    12 => "17時台",
    13 => "18時台",
    14 => "19時台",
    15 => "20時台",
    16 => "21時台",
    99 => "その他",
    100 => "不明"
  }

  def str_time_for_sairan
    return HASH_TIME_FOR_SAIRAN[self.time_for_sairan]
  end

  # choice_of_ishokutimeの区分値(移植の時間帯の選択余地)
  HASH_CHOICE_OF_ISHOKUTIME = {
    1 => "午前のみ(選択の余地なし)",
    2 => "午後のみ(選択の余地なし)",
    3 => "午前･午後を選択できた",
    4 => "時間指定ができた",
    99 => "その他",
    100 => "不明"
  }

  def str_choice_of_ishokutime
    return HASH_CHOICE_OF_ISHOKUTIME[self.choice_of_ishokutime]
  end

  # time_for_ishokuの区分値(移植の時間)
  HASH_TIME_FOR_ISHOKU = {
    1 => "6時台",
    2 => "7時台",
    3 => "8時台",
    4 => "9時台",
    5 => "10時台",
    6 => "11時台",
    7 => "12時台",
    8 => "13時台",
    9 => "14時台",
    10 => "15時台",
    11 => "16時台",
    12 => "17時台",
    13 => "18時台",
    14 => "19時台",
    15 => "20時台",
    16 => "21時台",
    99 => "その他",
    100 => "不明"
  }

  def str_time_for_ishoku
    return HASH_TIME_FOR_ISHOKU[self.time_for_ishoku]
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
    100 => "不明",
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
  }

  def str_blastocyst_grade2
    return HASH_BLASTOCYST_GRADE2[self.blastocyst_grade2]
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
    1 => "実施していた(指定PGT臨床研究機関)",
    2 => "非公式に実施していた",
    3 => "実施していなかった",
    4 => "ノーコメント",
    5 => "わからない",
  }

  def str_pgt1
    return HASH_PGT1[self.pgt1]
  end

  # pgtの区分値(患者側の受診有無)
  HASH_PGT2 = {
    1 => "受けていない",
    2 => "このクリニックで受けた",
    3 => "別のクリニックで受けた",
    4 => "ノーコメント",
  }

  def str_pgt2
    return HASH_PGT2[self.pgt2]
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

  # f_other_effort_cost m_other_effort_costの区分値(CL治療以外に行なったこと/月間平均投資額)
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

  def str_f_other_effort_cost
    return HASH_OTHER_EFFORT_COST[self.f_other_effort_cost]
  end

  def str_m_other_effort_cost
    return HASH_OTHER_EFFORT_COST[self.m_other_effort_cost]
  end

  # f_supplement_cost m_supplement_costの区分値(サプリ月間平均購入額)
  HASH_SUPPLEMENT_COST = {
    100 => "不明",
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
  }

  def str_f_supplement_cost
    return HASH_SUPPLEMENT_COST[self.f_supplement_cost]
  end

  def str_m_supplement_cost
    return HASH_SUPPLEMENT_COST[self.m_supplement_cost]
  end

  # sairan_costの区分値(CLでの1回あたりの採卵費用)
  HASH_SAIRAN_COST = {
    100 => "不明",
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
  }

  def str_sairan_cost
    return HASH_SAIRAN_COST[self.sairan_cost]
  end

  # ishoku_costの区分値(CLでの1回あたりの移植費用)
  HASH_ISHOKU_COST = {
    100 => "不明",
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
  }

  def str_ishoku_cost
    return HASH_ISHOKU_COST[self.ishoku_cost]
  end

  # costの区分値(CLでの費用総額)
  HASH_COST = {
    1000 => "不明",
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
  }

  def str_cost
    return HASH_COST[self.cost]
  end

  # credit_card_validityの区分値(クレジットカード使用可否)
  HASH_CREDIT_CARD_VALIDITY = {
    1 => "可",
    2 => "不可",
    3 => "一定の額から利用可",
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
    3 => "アプリ予約のみ",
    4 => "電話･webで予約",
    5 => "電話･アプリで予約",
    6 => "web･アプリで予約",
    7 => "電話･web･アプリで予約",
    8 => "予約不可",
    99 => "その他",
    100 => "不明"
  }

  def str_reservation_method
    return HASH_RESERVATION_METHOD[self.reservation_method]
  end

  # online_consultationの区分値(オンライン診療の有無)
  HASH_ONLINE_CONSULTATION = {
    1 => "なし",
    2 => "あり(初診は除く)",
    3 => "あり(初診もOK)",
    99 => "その他",
    100 => "不明"
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

  # briefing_sessionの区分値(説明会への有無と参加)
  HASH_BRIEFING_SESSION = {
    1 => "リアル説明会に参加",
    2 => "オンライン説明会に参加",
    3 => "どちらにも参加",
    4 => "どちらも参加せず",
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

  # smoking_female/maleの区分値(喫煙有無)
  HASH_SMOKING = {
    1 => "もとから非喫煙者",
    2 => "治療以前に禁煙済み",
    3 => "治療のために禁煙した",
    4 => "禁煙しなかった",
    99 => "その他"
  }

  def str_smoking_male
    return HASH_SMOKING[self.smoking_male]
  end

  def str_smoking_female
    return HASH_SMOKING[self.smoking_female]
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
      hash["#{i}つ前のクリニック"] = i
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

  # fertility_treatment_numberの区分値(何人目か)
  HASH_FERTILITY_TREATMENT_NUMBER = {
    1 => "1人目の治療",
    2 => "2人目の治療",
    3 => "3人以上の治療",
  }

  def str_fertility_treatment_number
    return HASH_FERTILITY_TREATMENT_NUMBER[self.fertility_treatment_number]
  end

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

  # treatment_start_ageの区分値(治療開始年齢/CL単位)
  HASH_TREATMENT_START_AGE = {
    100 => "不明",
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
  }

  def str_treatment_start_age
    return HASH_TREATMENT_START_AGE[self.treatment_start_age]
  end

  # treatment_end_ageの区分値(治療終了年齢/CL単位)
  HASH_TREATMENT_END_AGE = {
    100 => "不明",
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
  }

  def str_treatment_end_age
    return HASH_TREATMENT_END_AGE[self.treatment_end_age]
  end
  # searchでの年齢検索用の区分値(治療終了年齢/CL単位)
  HASH_TREATMENT_END_AGE_SEARCH = {
    100 => "不明",
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
  }

  def str_treatment_end_age_search
    return HASH_TREATMENT_END_AGE_SEARCH[self.treatment_end_age]
  end

  # age_of_partner_at_end_of_treatmentの区分値(治療終了時のパートナーの年齢/CL単位)
  HASH_AGE_OF_PARTNER_AT_END_OF_TREATMENT = {
    100 => "不明",
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
  }

  def str_age_of_partner_at_end_of_treatment
    return HASH_AGE_OF_PARTNER_AT_END_OF_TREATMENT[self.age_of_partner_at_end_of_treatment]
  end

  # sairan_ageの区分値(採卵時の年齢)
  HASH_SAIRAN_AGE = {
    100 => "不明",
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
  }

  def str_sairan_age
    return HASH_SAIRAN_AGE[self.sairan_age]
  end

  # ishoku_ageの区分値(移植時の年齢)
  HASH_ISHOKU_AGE = {
    100 => "不明",
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
  }

  def str_ishoku_age
    return HASH_ISHOKU_AGE[self.ishoku_age]
  end

  # total_number_of_sairanの区分値(全採卵回数/CL単位)
  HASH_TOTAL_NUMBER_OF_SAIRAN = {
    100 => "不明",
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
  }

  def str_total_number_of_sairan
    return HASH_TOTAL_NUMBER_OF_SAIRAN[self.total_number_of_sairan]
  end

  # ishoku_typeの区分値(移植周期のタイプ)
  HASH_ISHOKU_TYPE = {
    1 => "自然周期",
    2 => "ホルモン補充周期",
    99 => "その他",
    100 => "不明",
  }

  def str_ishoku_type
    return HASH_ISHOKU_TYPE[self.ishoku_type]
  end

  # total_number_of_transplantsの区分値(全移植回数/CL単位)
  HASH_TOTAL_NUMBER_OF_TRANSPLANTS = {
    100 => "不明",
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
  }

  def str_total_number_of_transplants
    return HASH_TOTAL_NUMBER_OF_TRANSPLANTS[self.total_number_of_transplants]
  end

  # 採卵前/移植前/卒業前までの通院回数質問にも利用
  def str_number_of_visits_before_sairan
    return HASH_TOTAL_NUMBER_OF_TRANSPLANTS[self.number_of_visits_before_sairan]
  end
  def str_number_of_visits_before_ishoku
    return HASH_TOTAL_NUMBER_OF_TRANSPLANTS[self.number_of_visits_before_ishoku]
  end
  def str_number_of_visits_before_pregnancy_date
    return HASH_TOTAL_NUMBER_OF_TRANSPLANTS[self.number_of_visits_before_pregnancy_date]
  end



  # total_number_of_eggs_transplantedの区分値(全移植個数/CL単位)
  HASH_TOTAL_NUMBER_OF_EGGS_TRANSPLANTED = {
    100 => "不明",
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
  }

  def str_total_number_of_eggs_transplanted
    return HASH_TOTAL_NUMBER_OF_EGGS_TRANSPLANTED[self.total_number_of_eggs_transplanted]
  end

  # number_of_eggs_collectedの区分値(採卵個数/CL単位)
  HASH_NUMBER_OF_EGGS_COLLECTED = {
    100 => "不明",
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
  }

  def str_number_of_eggs_collected
    return HASH_NUMBER_OF_EGGS_COLLECTED[self.number_of_eggs_collected]
  end

  # number_of_fertilized_eggsの区分値(最新採卵周期での受精した個数/CL単位)
  HASH_NUMBER_OF_FERTILIZED_EGGS = {
    100 => "不明",
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
  }

  def str_number_of_fertilized_eggs
    return HASH_NUMBER_OF_FERTILIZED_EGGS[self.number_of_fertilized_eggs]
  end

  # number_of_transferable_embryosの区分値(最新採卵周期での移植可能胚数/CL単位)
  HASH_NUMBER_OF_TRANSFERABLE_EMBRYOS = {
    100 => "不明",
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
  }

  def str_number_of_transferable_embryos
    return HASH_NUMBER_OF_TRANSFERABLE_EMBRYOS[self.number_of_transferable_embryos]
  end

  # number_of_frozen_eggsの区分値(最新周期での凍結できた数/CL単位)
  HASH_NUMBER_OF_FROZEN_EGGS = {
    100 => "不明",
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
  }

  def str_number_of_frozen_eggs
    return HASH_NUMBER_OF_FROZEN_EGGS[self.number_of_frozen_eggs]
  end

  # number_of_eggs_storedの区分値(凍結胚の在庫数/CL単位)
  HASH_NUMBER_OF_EGGS_STORED = {
    100 => "不明",
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
  }

  def str_number_of_eggs_stored
    return HASH_NUMBER_OF_EGGS_STORED[self.number_of_eggs_stored]
  end


  # pregnancy_dateの区分値(妊娠に判定日数)
  HASH_PREGNANCY_DATE = {
    4 => "ET/BT 4",
    5 => "ET/BT 5",
    6 => "ET/BT 6",
    7 => "ET/BT 7",
    8 => "ET/BT 8",
    9 => "ET/BT 9",
    10 => "ET/BT 10",
    11 => "ET/BT 11",
    12 => "ET/BT 12",
    13 => "ET/BT 13",
    14 => "ET/BT 14",
    15 => "ET/BT 15",
    16 => "ET/BT 16",
    17 => "ET/BT 17",
    18 => "ET/BT 18",
    19 => "ET/BT 19",
    20 => "ET/BT 20",
    99 => "それ以上",
    100 => "不明",
  }

  def str_pregnancy_date
    return HASH_PREGNANCY_DATE[self.pregnancy_date]
  end

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

  # free_wifiの区分値(CLにWiFiがあるかどうか)
  HASH_FREE_WIFI = {
    1 => "フリーWiFi なし",
    2 => "フリーWiFi あり",
    3 => "有料WiFi あり",
    99 => "その他",
    100 => "不明",
  }

  def str_free_wifi
    return HASH_FREE_WIFI[self.free_wifi]
  end

  # possible_to_wait_outside_clの区分値(院外で待てるかどうか)
  HASH_POSSIBLE_TO_WAIT_OUTSIDE_CL = {
    1 => "外出は不可",
    2 => "外出は可能",
    3 => "外出は可能(条件or制限付き)",
    99 => "その他",
    100 => "不明",
  }

  def str_possible_to_wait_outside_cl
    return HASH_POSSIBLE_TO_WAIT_OUTSIDE_CL[self.possible_to_wait_outside_cl]
  end

end

# == Schema Information
#
# Table name: reports
#
#  id                                           :bigint           not null, primary key
#  about_work_and_working_style                 :text
#  age_of_partner_at_end_of_treatment           :integer
#  amh                                          :integer
#  average_waiting_time                         :integer
#  average_waiting_time2                        :integer
#  blastocyst_grade1                            :integer
#  blastocyst_grade1_supplementary_explanation  :text
#  blastocyst_grade2                            :integer
#  blastocyst_grade2_supplementary_explanation  :text
#  briefing_session                             :integer
#  choice_of_ishokutime                         :integer
#  choice_of_sairantime                         :integer
#  city_at_the_time_status                      :integer          default("show"), not null
#  cl_female_inspection_memo                    :text
#  cl_male_inspection_memo                      :text
#  clinic_review                                :text
#  comfort_of_space                             :integer
#  content                                      :text
#  cost                                         :integer
#  cost_burden_memo                             :text
#  credit_card_validity                         :integer
#  creditcards_can_be_used_from_more_than       :integer
#  current_state                                :integer
#  description_of_eggs_and_sperm_used           :text
#  description_of_eggs_and_sperm_used_status    :text
#  details_of_icsi                              :integer
#  details_of_icsi_memo                         :text
#  doctor_quality                               :integer
#  early_embryo_grade                           :integer
#  early_embryo_grade_supplementary_explanation :text
#  egg_maturity                                 :integer
#  embryo_culture_days                          :integer
#  embryo_stage                                 :integer
#  explanation_and_impression_about_ishoku      :text
#  explanation_and_impression_about_sairan      :text
#  explanation_of_cost                          :text
#  f_disease_memo                               :text
#  f_other_effort_cost                          :integer
#  f_other_effort_memo                          :text
#  f_supplement_cost                            :integer
#  f_supplement_memo                            :text
#  f_surgery_memo                               :text
#  fertility_treatment_number                   :integer
#  followup_investigation                       :integer
#  followup_investigation_memo                  :text
#  free_wifi                                    :integer
#  fuiku                                        :integer
#  fuiku_supplementary_explanation              :text
#  household_net_income                         :integer
#  household_net_income_status                  :integer          default("show"), not null
#  how_long_to_continue_treatment               :integer
#  how_long_to_continue_treatment2              :integer
#  how_long_to_continue_treatment_memo          :text
#  impression_of_price                          :integer
#  impression_of_technology                     :integer
#  industry_type                                :integer
#  industry_type_status                         :integer          default("show"), not null
#  injection_memo                               :text
#  ishoku_age                                   :integer
#  ishoku_cost                                  :integer
#  ishoku_cost_explanation                      :text
#  ishoku_medicine_memo                         :text
#  ishoku_type                                  :integer
#  m_disease_memo                               :text
#  m_other_effort_cost                          :integer
#  m_other_effort_memo                          :text
#  m_supplement_cost                            :integer
#  m_supplement_memo                            :text
#  m_surgery_memo                               :text
#  notes_on_type_of_sairan_cycle                :text
#  number_of_clinics                            :integer
#  number_of_eggs_collected                     :integer
#  number_of_eggs_stored                        :integer
#  number_of_fertilized_eggs                    :integer
#  number_of_frozen_eggs                        :integer
#  number_of_injections                         :integer
#  number_of_transferable_embryos               :integer
#  number_of_visits_before_ishoku               :integer
#  number_of_visits_before_pregnancy_date       :integer
#  number_of_visits_before_sairan               :integer
#  online_consultation                          :integer
#  online_consultation_details                  :text
#  ova_with_ivm                                 :integer
#  period_of_time_spent_traveling               :integer
#  pgt1                                         :integer
#  pgt1_status                                  :integer          default("show"), not null
#  pgt2                                         :integer
#  pgt2_status                                  :integer          default("show"), not null
#  pgt_supplementary_explanation                :text
#  pgt_supplementary_explanation_status         :integer          default("show"), not null
#  possible_to_wait_outside_cl                  :integer
#  prefecture_at_the_time_status                :integer          default("show"), not null
#  pregnancy_date                               :integer
#  pregnancy_date_memo                          :text
#  probability_of_normal_morphology_of_sperm    :float
#  reason_for_transfer                          :text
#  reasons_for_choosing_this_clinic             :text
#  reservation_method                           :integer
#  reservation_method_memo                      :text
#  rest_period                                  :integer
#  rest_period_memo                             :text
#  sairan_age                                   :integer
#  sairan_cost                                  :integer
#  sairan_cost_explanation                      :text
#  sairan_medicine_memo                         :text
#  selection_of_anesthesia_type                 :integer
#  self_injection                               :integer
#  semen_concentration                          :integer
#  semen_volume                                 :float
#  smoking_female                               :integer
#  smoking_male                                 :integer
#  special_inspection_memo                      :text
#  sperm_advance_rate                           :float
#  sperm_description                            :text
#  sperm_motility                               :float
#  staff_quality                                :integer
#  status                                       :integer          default("released"), not null
#  suspended_or_retirement_job                  :integer
#  time_for_ishoku                              :integer
#  time_for_sairan                              :integer
#  title                                        :string
#  total_amount_of_sperm                        :integer
#  total_number_of_eggs_transplanted            :integer
#  total_number_of_sairan                       :integer
#  total_number_of_transplants                  :integer
#  transfer_option_memo                         :text
#  transplant_method                            :integer
#  treatment_end_age                            :integer
#  treatment_period                             :integer
#  treatment_policy                             :text
#  treatment_schedule_memo                      :text
#  treatment_start_age                          :integer
#  treatment_support_system                     :integer
#  type_of_ovarian_stimulation                  :integer
#  type_of_sairan_cycle                         :integer
#  types_of_eggs_and_sperm                      :integer
#  types_of_eggs_and_sperm_status               :integer
#  types_of_fertilization_methods               :integer
#  types_of_fertilization_methods_memo          :text
#  use_of_anesthesia                            :integer
#  work_style                                   :integer
#  work_style_status                            :integer          default("show"), not null
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
