class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, uniqueness: true
  validates_acceptance_of :agreement, allow_nil: false, message: "※会員登録には利用規約への同意が必要です。", on: :create
  
  VALID_PASSWORD_REGEX = /\A[a-z0-9]+\z/i
  validates :password, format: { with: VALID_PASSWORD_REGEX },
                      # user情報をpassword無しで更新する場合はスルー↓(https://hinakochang.hatenablog.com/entry/2019/01/29/134920)
                      if: -> { new_record? || changes['encrypted_password'] }, allow_blank: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :timeoutable

  has_many :reports, dependent: :destroy
  has_many :comments
  has_one_attached :icon
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :liked_reports, through: :likes, source: :report
  def already_liked?(report)
    self.likes.exists?(report_id: report.id)
  end

  # 退会処理(論理削除)→https://qiita.com/yuto_1014/items/358d0a425193b12c969a

  # carrierwave→activestrage変更に伴いmount解除(user/iconカラムも削除済み)↓
  # mount_uploader :icon, ImageUploader

  enum gender: { female: 0, male: 1 }

  enum number_of_chemical_abortions_status: { show: 0, hide: 1 }, _prefix: true
  enum number_of_early_miscarriages_status: { show: 0, hide: 1 }, _prefix: true
  enum number_of_late_miscarriages_status: { show: 0, hide: 1 }, _prefix: true

  # ゲストログイン機能(参考: https://qiita.com/take18k_tech/items/35f9b5883f5be4c6e104)
  # def self.guest
  #   find_or_create_by!(email: 'guest@example.com') do |user|
  #     user.password = SecureRandom.urlsafe_base64(10)
  #     user.confirmed_at = Time.now
  #   end
  # end
  # ここまで(ゲストログイン機能)

  # passwordの入力無しでuser情報を更新する
  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end

  def registration_status1
    registration_status1 = []
    registration_status1 = [self.first_age_to_start, self.first_age_to_start_art, self.number_of_aih, self.all_number_of_sairan, self.all_number_of_transplants, self.all_cost, self.number_of_chemical_abortions, self.number_of_early_miscarriages, self.number_of_late_miscarriages, self.number_of_times_the_grant_was_received, self.all_grant_amount]
    if registration_status1.include?(nil)
      true
    else
      false
    end
  end

  def registration_status2
    registration_status2 = []
    registration_status2 = [self.self_introduction]
    if registration_status2.include?(nil) || registration_status2.include?("")
      true
    else
      false
    end
  end

  # 回数(0回なし)
  HASH_IVF_COUNT = {
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

  def str_all_number_of_sairan(sairan)
    return HASH_IVF_COUNT[sairan]
  end

  def str_all_number_of_transplants(ishoku)
    return HASH_IVF_COUNT[ishoku]
  end

  # 回数(0回あり)
  HASH_AIH_COUNT = {
    0 => "なし",
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

  def str_number_of_aih(aih)
    return HASH_AIH_COUNT[aih]
  end

  # 年齢
  HASH_AGE = {
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

  def str_first_age_to_start(age)
    return HASH_AGE[age]
  end

  def str_first_age_to_start_art(age_art)
    return HASH_AGE[age_art]
  end


  # 費用総額
  HASH_ALL_COST = {
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

  def str_all_cost(cost)
    return HASH_ALL_COST[cost]
  end

  def str_all_cost_report
    return HASH_ALL_COST[self.all_cost]
  end

  # 助成金
  HASH_JOSEIKIN = {
    100 => "不明",
    0 => "受給したことはない",
    1 => "〜5万円未満",
    2 => "〜10万円未満",
    3 => "〜15万円未満",
    4 => "〜20万円未満",
    5 => "〜25万円未満",
    6 => "〜30万円未満",
    7 => "〜35万円未満",
    8 => "〜40万円未満",
    9 => "〜45万円未満",
    10 => "〜50万円未満",
    11 => "〜55万円未満",
    12 => "〜60万円未満",
    13 => "〜65万円未満",
    14 => "〜70万円未満",
    15 => "〜75万円未満",
    16 => "〜80万円未満",
    17 => "〜85万円未満",
    18 => "〜90万円未満",
    19 => "〜95万円未満",
    20 => "〜100万円未満",
    99 => "100万円以上",
  }

  def str_all_grant_amount(josei)
    return HASH_JOSEIKIN[josei]
  end

  # 助成金受給回数
  HASH_JOSEIKIN_COUNT = {
    0 => "0回",
    1 => "1回",
    2 => "2回",
    3 => "3回",
    4 => "4回",
    5 => "5回",
    6 => "6回",
    99 => "その他",
    100 => "不明"
  }

  def str_number_of_times_the_grant_was_received(josei)
    return HASH_JOSEIKIN_COUNT[josei]
  end

  # 流産回数
  HASH_RYUZAN_COUNT = {
    1 => "なし",
    2 => "1回",
    3 => "2回",
    4 => "3回以上",
    0 => "無回答",
  }

  def str_number_of_chemical_abortions(chemical)
    return HASH_RYUZAN_COUNT[chemical]
  end

  def str_number_of_early_miscarriages(early)
    return HASH_RYUZAN_COUNT[early]
  end

  def str_number_of_late_miscarriages(late)
    return HASH_RYUZAN_COUNT[late]
  end
end

# == Schema Information
#
# Table name: users
#
#  id                                     :bigint           not null, primary key
#  all_cost                               :integer
#  all_grant_amount                       :integer
#  all_number_of_sairan                   :integer
#  all_number_of_transplants              :integer
#  birthday                               :datetime
#  confirmation_sent_at                   :datetime
#  confirmation_token                     :string
#  confirmed_at                           :datetime
#  current_sign_in_at                     :datetime
#  current_sign_in_ip                     :inet
#  email                                  :string           default(""), not null
#  encrypted_password                     :string           default(""), not null
#  first_age_to_start                     :integer
#  first_age_to_start_art                 :integer
#  gender                                 :integer          default("female"), not null
#  image_url                              :string
#  is_deleted                             :boolean          default(FALSE)
#  last_sign_in_at                        :datetime
#  last_sign_in_ip                        :inet
#  link                                   :string
#  name                                   :string
#  number_of_aih                          :integer
#  number_of_chemical_abortions           :integer
#  number_of_chemical_abortions_status    :integer          default("show"), not null
#  number_of_early_miscarriages           :integer
#  number_of_early_miscarriages_status    :integer          default("show"), not null
#  number_of_late_miscarriages            :integer
#  number_of_late_miscarriages_status     :integer          default("show"), not null
#  number_of_times_the_grant_was_received :integer
#  provider                               :string
#  remember_created_at                    :datetime
#  reset_password_sent_at                 :datetime
#  reset_password_token                   :string
#  self_introduction                      :text
#  sign_in_count                          :integer          default(0), not null
#  uid                                    :string
#  unconfirmed_email                      :string
#  username                               :string
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_provider_and_uid      (provider,uid) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
