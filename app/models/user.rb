class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, uniqueness: true
  
  VALID_PASSWORD_REGEX = /\A[a-z0-9]+\z/i
  validates :password, format: { with: VALID_PASSWORD_REGEX },
                      # user情報をpassword無しで更新する場合はスルー↓(https://hinakochang.hatenablog.com/entry/2019/01/29/134920)
                      if: -> { new_record? || changes['encrypted_password'] }, allow_blank: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable

  has_many :reports, dependent: :destroy
  has_many :comments
  has_one_attached :icon
  has_many :likes, dependent: :destroy
  has_many :like_reports, through: :likes, source: :report
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  # carrierwave→activestrage変更に伴いmount解除(user/iconカラムも削除済み)↓
  # mount_uploader :icon, ImageUploader

  enum gender: { female: 0, male: 1 }

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
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  birthday               :datetime
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  gender                 :integer          default("female"), not null
#  image_url              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  link                   :string
#  name                   :string
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  self_introduction      :text
#  sign_in_count          :integer          default(0), not null
#  uid                    :string
#  unconfirmed_email      :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_provider_and_uid      (provider,uid) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
