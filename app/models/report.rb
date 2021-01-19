class Report < ApplicationRecord

  # レポートの公開状況 参考:https://qiita.com/tomoharutt/items/f1a70babaddcf7ab47be
  enum status: { released: 0, nonreleased: 1 }

  # 仕事セクションの(年収などの項目）公開状況 参考:https://qiita.com/emacs_hhkb/items/fce19f443e5770ad2e13
  enum work_style_status: { show: 0, hide: 1 }, _prefix: true

  # 治療当時の住まいの公開状況 参考:http://mnmandahalf.hatenablog.com/entry/2017/08/20/164442
  enum prefecture_at_the_time_status: { show: 0, hide: 1 }, _prefix: true
  enum city_at_the_time_status: { show: 0, hide: 1 }, _prefix: true

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

  def previous
    Report.where("id < ?", self.id).where(status: 0).order("id DESC").first
  end

  def next
    Report.where("id > ?", self.id).where(status: 0).order("id ASC").first
  end

  def self.rank
    Report.find(Like.joins(:report).where(reports: {status: 0}).group(:report_id).order('count(report_id) desc').limit(5).pluck(:report_id))
  end

  def self.same_cl(report)
    Report.where(status: 0, clinic_id: report.clinic_id).where.not(id: report.id).limit(5)
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

  # 不育症の原因
  has_many :report_fuiku_inspections, dependent: :destroy
  has_many :fuiku_inspections, through: :report_fuiku_inspections

  # 女性不妊の原因
  has_many :report_f_funin_factors, dependent: :destroy
  has_many :f_funin_factors, through: :report_f_funin_factors

  # 移植オプション
  has_many :report_transfer_options, dependent: :destroy
  has_many :transfer_options, through: :report_transfer_options

  # CL選定理由
  has_many :report_cl_selections, dependent: :destroy
  has_many :cl_selections, through: :report_cl_selections

  # 黄体補充
  has_many :report_pg_eplenishments, dependent: :destroy
  has_many :pg_eplenishments, through: :report_pg_eplenishments

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
    2 => "妊娠中(多胎)",
    3 => "出産",
    4 => "出産(多胎)",
    99 => "その他"
  }

  def str_current_state
    return HASH_CURRENT_STATE[self.current_state]
  end

  # 検索画面用のcurrent_stateの区分値(現在の状況)
  HASH_CURRENT_STATE_SEARCH = {
    1 => "妊娠中",
    2 => "妊娠中(多胎)",
    3 => "出産",
    4 => "出産(多胎)",
    99 => "その他"
  }

  def str_current_state_search
    return HASH_CURRENT_STATE_SEARCH[self.current_state]
  end

  # treatment_periodの区分値(休み期間除く正味治療期間/CL単位)
  HASH_TREATMENT_PERIOD = {
    1 => "〜3ヵ月",
    2 => "〜半年",
    3 => "〜1年",
    4 => "〜2年",
    5 => "〜3年",
    6 => "〜4年",
    99 => "5年以上",
    100 => "不明",
  }

  def str_treatment_period
    return HASH_TREATMENT_PERIOD[self.treatment_period]
  end

  # amhの区分値(AMH値)
  HASH_AMH = {
    1000 => "不明",
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
    15 => "1.5以下",
    20 => "2.0以下",
    25 => "2.5以下",
    30 => "3.0以下",
    35 => "3.5以下",
    40 => "4.0以下",
    45 => "4.5以下",
    50 => "5.0以下",
    55 => "5.5以下",
    60 => "6.0以下",
    65 => "6.5以下",
    70 => "7.0以下",
    75 => "7.5以下",
    80 => "8.0以下",
    85 => "8.5以下",
    90 => "9.0以下",
    95 => "9.5以下",
    100 => "10.0以下",
    999 => "それ以上",
  }

  def str_amh
    return HASH_AMH[self.amh]
  end

  # 検索画面用のamhの区分値(AMH値)
  HASH_AMH_SEARCH = {
    1000 => "不明",
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
    15 => "1.5以下",
    20 => "2.0以下",
    25 => "2.5以下",
    30 => "3.0以下",
    35 => "3.5以下",
    40 => "4.0以下",
    45 => "4.5以下",
    50 => "5.0以下",
    55 => "5.5以下",
    60 => "6.0以下",
    65 => "6.5以下",
    70 => "7.0以下",
    75 => "7.5以下",
    80 => "8.0以下",
    85 => "8.5以下",
    90 => "9.0以下",
    95 => "9.5以下",
    100 => "10.0以下",
    999 => "それ以上",
  }

  def str_amh_search
    return HASH_AMH_SEARCH[self.amh]
  end

  # use_of_anesthesiaの区分値(麻酔の種類)
  HASH_USE_OF_ANESTHESIA = {
    1 => "局所麻酔",
    2 => "全身麻酔(静脈麻酔)",
    3 => "無麻酔",
    99 => "その他",
    100 => "不明"
  }


  def str_use_of_anesthesia
    return HASH_USE_OF_ANESTHESIA[self.use_of_anesthesia]
  end

  # selection_of_anesthesia_typeの区分値(麻酔の有無&種類に関しての選択の余地)
  HASH_SELECTION_OF_ANESTHESIA_TYPE = {
    1 => "選択できた",
    2 => "選択できなかった",
    99 => "その他",
    100 => "不明"
  }

  def str_selection_of_anesthesia_type
    return HASH_SELECTION_OF_ANESTHESIA_TYPE[self.selection_of_anesthesia_type]
  end

  # type_of_ovarian_stimulationの区分値(採卵周期大分類)
  HASH_TYPE_OF_OVARIAN_STIMULATION = {
    1 => "刺激なし",
    2 => "低刺激(内服のみ)",
    3 => "中刺激(内服+注射3回程度)",
    4 => "高刺激(内服+注射4回以上)",
    99 => "その他",
    100 => "不明"
  }

  def str_type_of_ovarian_stimulation
    return HASH_TYPE_OF_OVARIAN_STIMULATION[self.type_of_ovarian_stimulation]
  end

  # types_of_fertilization_methodsの区分値(受精方法)
  HASH_TYPES_OF_FERTILIZATION_METHODS = {
    1 => "体外受精",
    2 => "顕微授精",
    3 => "スプリット(体外･顕微両方)",
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

  # male_infertilityの区分値(男性不妊因子)
  HASH_MALE_INFERTILITY = {
    1 => "なし",
    2 => "あり",
    3 => "不明"
  }

  def str_male_infertility
    return HASH_MALE_INFERTILITY[self.male_infertility]
  end

  # level_of_male_infertilityの区分値(男性不妊因子のレベル)
  HASH_LEVEL_OF_MALE_INFERTILITY = {
    1 => "人工授精レベル",
    2 => "顕微授精レベル",
    3 => "TESE以上レベル",
    99 => "その他",
    100 => "不明",
  }

  def str_level_of_male_infertility
    return HASH_LEVEL_OF_MALE_INFERTILITY[self.level_of_male_infertility]
  end

  # transplant_methodの区分値(移植胚の種類)
  HASH_TRANSPLANT_METHOD = {
    1 => "凍結胚",
    2 => "新鮮胚",
    99 => "その他",
    100 => "不明"
  }

  def str_transplant_method
    return HASH_TRANSPLANT_METHOD[self.transplant_method]
  end

  # embryo_stageの区分値(妊娠に至った胚のステージ)
  HASH_EMBRYO_STAGE = {
    1 => "〜初期胚",
    2 => "胚盤胞",
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
  # ↓show用
  HASH_EARLY_EMBRYO_GRADE_SHOW = {
    1 => "グレード1",
    2 => "グレード2",
    3 => "グレード3",
    4 => "グレード4",
    5 => "グレード5",
    9 => "",
    100 => ""
  }
  def str_early_embryo_grade_show
    return HASH_EARLY_EMBRYO_GRADE_SHOW[self.early_embryo_grade]
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
  # ↓show用
  HASH_BLASTOCYST_GRADE1_SHOW = {
    1 => "1",
    2 => "2",
    3 => "3",
    4 => "4",
    5 => "5",
    6 => "6",
    99 => "",
    100 => ""
  }
  def str_blastocyst_grade1_show
    return HASH_BLASTOCYST_GRADE1_SHOW[self.blastocyst_grade1]
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
    99 => "その他",
    100 => "不明"
  }

  def str_blastocyst_grade2
    return HASH_BLASTOCYST_GRADE2[self.blastocyst_grade2]
  end
  # ↓show用
  HASH_BLASTOCYST_GRADE2_SHOW = {
    100 => "",
    1 => "AA",
    2 => "AB",
    3 => "AC",
    4 => "BA",
    5 => "BB",
    6 => "BC",
    7 => "CA",
    8 => "CB",
    9 => "CC",
    10 => "A + ?",
    11 => "B + ?",
    12 => "C + ?",
    13 => "? + A",
    14 => "? + B",
    15 => "? + C",
    99 => "",
  }

  def str_blastocyst_grade2_show
    return HASH_BLASTOCYST_GRADE2_SHOW[self.blastocyst_grade2]
  end

  # culture_daysの区分値(培養日数)
  HASH_CULTURE_DAYS = {
    5 => "5日目",
    6 => "6日目",
    7 => "7日目",
    99 => "その他",
    100 => "不明"
  }

  def str_culture_days
    return HASH_CULTURE_DAYS[self.culture_days]
  end

  # fuikuの区分値(不育症の診断有無)
  HASH_FUIKU = {
    1 => "なし",
    2 => "あり",
    99 => "その他",
    100 => "不明",
  }

  def str_fuiku
    return HASH_FUIKU[self.fuiku]
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
    21 => "200万円以上",
  }

  def str_sairan_cost
    return HASH_SAIRAN_COST[self.sairan_cost]
  end

  # 検索画面用sairan_costの区分値(CLでの1回あたりの採卵費用)
  HASH_SAIRAN_COST_SEARCH = {
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
    21 => "200万円以上",
  }

  def str_sairan_cost_search
    return HASH_SAIRAN_COST_SEARCH[self.sairan_cost]
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
    21 => "200万円以上",
  }

  def str_ishoku_cost
    return HASH_ISHOKU_COST[self.ishoku_cost]
  end

  # 検索画面用ishoku_costの区分値(CLでの1回あたりの移植費用)
  HASH_ISHOKU_COST_SEARCH = {
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
    21 => "200万円以上",
  }

  def str_ishoku_cost_search
    return HASH_ISHOKU_COST_SEARCH[self.ishoku_cost]
  end

  # costの区分値(CLでの費用総額)
  HASH_COST = {
    100 => "不明",
    1 => "30万円未満",
    2 => "50万円未満",
    3 => "100万円未満",
    4 => "150万円未満",
    5 => "200万円未満",
    6 => "250万円未満",
    7 => "300万円未満",
    8 => "350万円未満",
    9 => "400万円未満",
    10 => "450万円未満",
    11 => "500万円未満",
    12 => "600万円未満",
    13 => "700万円未満",
    14 => "800万円未満",
    15 => "900万円未満",
    16 => "1,000万円未満",
    17 => "1,000万円以上",
  }

  def str_cost
    return HASH_COST[self.cost]
  end

  # 検索画面用のcostの区分値(CLでの費用総額)
  HASH_COST_SEARCH= {
    100 => "不明",
    1 => "30万円未満",
    2 => "50万円未満",
    3 => "100万円未満",
    4 => "150万円未満",
    5 => "200万円未満",
    6 => "250万円未満",
    7 => "300万円未満",
    8 => "350万円未満",
    9 => "400万円未満",
    10 => "450万円未満",
    11 => "500万円未満",
    12 => "600万円未満",
    13 => "700万円未満",
    14 => "800万円未満",
    15 => "900万円未満",
    16 => "1,000万円未満",
    17 => "1,000万円以上",
  }

  def str_cost_search
    return HASH_COST_SEARCH[self.cost]
  end

  # credit_card_validityの区分値(クレジットカード使用可否)
  HASH_CREDIT_CARD_VALIDITY = {
    1 => "可",
    2 => "不可",
    3 => "一定の額から利用可",
    100 => "不明"
    }

  def str_credit_card_validity
    return HASH_CREDIT_CARD_VALIDITY[self.credit_card_validity]
  end

  # average_waiting_timeの区分値(クリニックでの平均待ち時間)
  HASH_AVERAGE_WAITING_TIME = {
    0 => "〜30分",
    1 => "〜1時間",
    2 => "〜2時間",
    3 => "〜3時間",
    4 => "4時間以上"
  }

  def str_average_waiting_time
    return HASH_AVERAGE_WAITING_TIME[self.average_waiting_time]
  end

  # period_of_time_spent_travelingの区分値(通院時間)
  HASH_PERIOD_OF_TIME_SPENT_TRAVELING = {
    0 => "30分圏内",
    1 => "1時間圏内",
    2 => "2時間圏内",
    3 => "3時間圏内",
    4 => "4時間圏内",
    99 => "5時間以上"
  }

  def str_period_of_time_spent_traveling
    return HASH_PERIOD_OF_TIME_SPENT_TRAVELING[self.period_of_time_spent_traveling]
  end

  # work_styleの区分値(働き方)
  HASH_WORK_STYLE = {
    1 => "会社員",
    2 => "自営業/フリーランス",
    3 => "パート",
    4 => "無職",
    99 => "その他"
  }

  def str_work_style
    return HASH_WORK_STYLE[self.work_style]
  end

  # 検索画面用のwork_styleの区分値(働き方)
  HASH_WORK_STYLE_SEARCH= {
    1 => "会社員",
    2 => "自営業/フリーランス",
    3 => "パート",
    4 => "無職",
    99 => "その他"
  }

  def str_work_style_search
    return HASH_WORK_STYLE_SEARCH[self.work_style]
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
    hash = {
      1 => "1つ前のクリニック",
      2 => "2つ前のクリニック",
      3 => "3つ前のクリニック",
      4 => "4つ前のクリニック",
      5 => "5つ前のクリニック",
      6 => "6つ前のクリニック",
      7 => "7つ前のクリニック",
      8 => "8つ前のクリニック",
      9 => "9つ前のクリニック",
      99 => "それ以上前のクリニック",
    }
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
    1 => "1人目治療",
    2 => "2人目治療",
    3 => "3人以上治療",
  }

  def str_fertility_treatment_number
    return HASH_FERTILITY_TREATMENT_NUMBER[self.fertility_treatment_number]
  end

  # 検索画面用のfertility_treatment_numberの区分値(何人目か)
  HASH_FERTILITY_TREATMENT_NUMBER_SEARCH = {
    1 => "1人目治療",
    2 => "2人目治療",
    3 => "3人目〜治療",
  }

  def str_fertility_treatment_number_search
    return HASH_FERTILITY_TREATMENT_NUMBER_SEARCH[self.fertility_treatment_number]
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
    11 => "11院以上",
    100 => "不明",
  }

  def str_number_of_clinics
    return HASH_NUMBER_OF_CLINICS[self.number_of_clinics]
  end

  # treatment_end_ageの区分値(治療終了年齢/CL単位)
  HASH_TREATMENT_END_AGE = {
    100 => "不明",
    19 => "20歳未満",
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
    50 => "50歳以上",
  }

  def str_treatment_end_age
    return HASH_TREATMENT_END_AGE[self.treatment_end_age]
  end
  # searchでの年齢検索用の区分値(治療終了年齢/CL単位)
  HASH_TREATMENT_END_AGE_SEARCH = {
    100 => "不明",
    19 => "20歳未満",
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
    50 => "50歳以上",
  }

  def str_treatment_end_age_search
    return HASH_TREATMENT_END_AGE_SEARCH[self.treatment_end_age]
  end

  # age_of_partner_at_end_of_treatmentの区分値(治療終了時のパートナーの年齢/CL単位)
  HASH_AGE_OF_PARTNER_AT_END_OF_TREATMENT = {
    100 => "不明",
    19 => "20歳未満",
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
    50 => "50歳以上",
  }

  def str_age_of_partner_at_end_of_treatment
    return HASH_AGE_OF_PARTNER_AT_END_OF_TREATMENT[self.age_of_partner_at_end_of_treatment]
  end

  # sairan_ageの区分値(採卵時の年齢)
  HASH_SAIRAN_AGE = {
    100 => "不明",
    19 => "20歳未満",
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
    45 => "45歳以上",
  }

  def str_sairan_age
    return HASH_SAIRAN_AGE[self.sairan_age]
  end

  # ishoku_ageの区分値(移植時の年齢)
  HASH_ISHOKU_AGE = {
    100 => "不明",
    19 => "20歳未満",
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
    45 => "45歳以上",
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
    15 => "15回〜",
    100 => "不明",
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
    15 => "15回〜",
    100 => "不明",
  }

  def str_total_number_of_transplants
    return HASH_TOTAL_NUMBER_OF_TRANSPLANTS[self.total_number_of_transplants]
  end

  # 採卵前までの通院回数質問にも利用
  HASH_NUMBER_OF_VISITS_BEFORE_SAIRAN = {
    1 => "1〜3回",
    2 => "4〜5回",
    3 => "6回以上",
    100 => "不明",
  }

  def str_number_of_visits_before_sairan
    return HASH_NUMBER_OF_VISITS_BEFORE_SAIRAN[self.number_of_visits_before_sairan]
  end

  # 移植前までの通院回数質問にも利用
  HASH_NUMBER_OF_VISITS_BEFORE_ISHOKU = {
    1 => "1〜3回",
    2 => "4〜5回",
    3 => "6回以上",
    100 => "不明",
  }

  def str_number_of_visits_before_ishoku
    return HASH_NUMBER_OF_VISITS_BEFORE_ISHOKU[self.number_of_visits_before_ishoku]
  end


  # total_number_of_eggs_transplantedの区分値(全移植個数/CL単位)
  HASH_TOTAL_NUMBER_OF_EGGS_TRANSPLANTED = {
    1 => "1個",
    2 => "2個",
    3 => "3個",
    4 => "4個",
    5 => "5個以上",
    100 => "不明",
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
    51 => "51個以上",
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
    51 => "51個以上",
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
    51 => "51個以上",
  }

  def str_number_of_transferable_embryos
    return HASH_NUMBER_OF_TRANSFERABLE_EMBRYOS[self.number_of_transferable_embryos]
  end

  # number_of_unfrozen_embryosの区分値(最新採卵周期での新鮮胚数/CL単位)
  HASH_NUMBER_OF_UNFROZEN_EMBRYOS = {
    0 => "0個",
    1 => "1個",
    2 => "2個",
    3 => "3個",
    4 => "4個",
    99 => "5個以上",
    100 => "不明",
  }

  def str_number_of_unfrozen_embryos
    return HASH_NUMBER_OF_UNFROZEN_EMBRYOS[self.number_of_unfrozen_embryos]
  end

  # number_of_frozen_pronuclear_embryosの区分値(最新採卵周期での前核胚数/CL単位)
  HASH_NUMBER_OF_FROZEN_PRONUCLEAR_EMBRYOS = {
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
    51 => "51個以上",
  }

  def str_number_of_frozen_pronuclear_embryos
    return HASH_NUMBER_OF_FROZEN_PRONUCLEAR_EMBRYOS[self.number_of_frozen_pronuclear_embryos]
  end

  # number_of_frozen_early_embryosの区分値(最新採卵周期での初期胚数/CL単位)
  HASH_NUMBER_OF_FROZEN_EARLY_EMBRYOS = {
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
    51 => "51個以上",
  }

  def str_number_of_frozen_early_embryos
    return HASH_NUMBER_OF_FROZEN_EARLY_EMBRYOS[self.number_of_frozen_early_embryos]
  end

  # number_of_frozen_blastocystsの区分値(最新採卵周期での胚盤胞数/CL単位)
  HASH_NUMBER_OF_FROZEN_BLASTOCYSTS = {
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
    51 => "51個以上",
  }

  def str_number_of_frozen_blastocysts
    return HASH_NUMBER_OF_FROZEN_BLASTOCYSTS[self.number_of_frozen_blastocysts]
  end

  # CL評価の区分値(CL評価)
  HASH_RATING = {
    1 => "1",
    2 => "2",
    3 => "3",
    4 => "4",
    5 => "5",
  }

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
    1 => "外出不可",
    2 => "外出可能",
    3 => "外出可能(条件/制限あり)",
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
#  id                                     :bigint           not null, primary key
#  age_of_partner_at_end_of_treatment     :integer
#  amh                                    :integer
#  average_waiting_time                   :integer
#  average_waiting_time2                  :integer
#  blastocyst_grade1                      :integer
#  blastocyst_grade2                      :integer
#  city_at_the_time_status                :integer          default("show"), not null
#  clinic_review                          :text
#  comfort_of_space                       :integer
#  content                                :text
#  cost                                   :integer
#  credit_card_validity                   :integer
#  creditcards_can_be_used_from_more_than :integer
#  culture_days                           :integer
#  current_state                          :integer
#  details_of_icsi                        :integer
#  doctor_quality                         :integer
#  early_embryo_grade                     :integer
#  embryo_stage                           :integer
#  fertility_treatment_number             :integer
#  free_wifi                              :integer
#  fuiku                                  :integer
#  impression_of_price                    :integer
#  impression_of_technology               :integer
#  ishoku_age                             :integer
#  ishoku_cost                            :integer
#  ishoku_type                            :integer
#  level_of_male_infertility              :integer
#  male_infertility                       :integer
#  number_of_clinics                      :integer
#  number_of_eggs_collected               :integer
#  number_of_fertilized_eggs              :integer
#  number_of_frozen_blastocysts           :integer
#  number_of_frozen_early_embryos         :integer
#  number_of_frozen_pronuclear_embryos    :integer
#  number_of_transferable_embryos         :integer
#  number_of_unfrozen_embryos             :integer
#  number_of_visits_before_ishoku         :integer
#  number_of_visits_before_sairan         :integer
#  ova_with_ivm                           :integer
#  period_of_time_spent_traveling         :integer
#  possible_to_wait_outside_cl            :integer
#  prefecture_at_the_time_status          :integer          default("show"), not null
#  reason_for_transfer                    :text
#  reasons_for_choosing_this_clinic       :text
#  sairan_age                             :integer
#  sairan_cost                            :integer
#  selection_of_anesthesia_type           :integer
#  staff_quality                          :integer
#  status                                 :integer          default("released"), not null
#  title                                  :string
#  total_number_of_eggs_transplanted      :integer
#  total_number_of_sairan                 :integer
#  total_number_of_transplants            :integer
#  transplant_method                      :integer
#  treatment_end_age                      :integer
#  treatment_period                       :integer
#  treatment_policy                       :text
#  type_of_ovarian_stimulation            :integer
#  types_of_fertilization_methods         :integer
#  use_of_anesthesia                      :integer
#  work_style                             :integer
#  work_style_status                      :integer          default("show"), not null
#  year_of_treatment_end                  :date
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  city_id                                :bigint
#  clinic_id                              :bigint           not null
#  prefecture_id                          :bigint
#  user_id                                :bigint           not null
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
