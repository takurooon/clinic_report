# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :authenticate_user!

  # ゲストログイン機能(参考: https://qiita.com/take18k_tech/items/35f9b5883f5be4c6e104)
  # before_action :check_guest, only: %i[update destroy]
  # def check_guest
  #   if resource.email == 'guest@example.com'
  #     redirect_to root_path, alert: 'ゲストユーザーの変更・削除はできません。'
  #   end
  # end
  # ここまで(ゲストログイン機能)

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super do                                             # 他はdeviseの機能をそのまま流用する(https://qiita.com/ozackiee/items/21fcad4a1564136b9510)
  #     resource.update(confirmed_at: Time .now.utc)       # Welcomeメールを送信した上で、skip_confirmation!と同一処理を行い自動で認証クローズさせる
  #     #↓と同じ意味
  #     # resource.skip_confirmation!
  #     # resource.save
  #   end
  # end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  # def update
  #   super
      # ↓はupdate_resourceに移動
  #   if account_update_params[:icon].present?
  #     resource.icon.attach(account_update_params[:icon])
  #   end
  # end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # 追加：パスワードの入力無しでuser情報を更新する(https://kossy-web-engineer.hatenablog.com/entry/2018/11/06/102047)
  def update_resource(resource, params)
    resource.update_without_current_password(params)

    # 参考URL https://qiita.com/eitches/items/6f1d80b21287e09a7477
    if account_update_params[:icon].present?
      resource.icon.attach(account_update_params[:icon])
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # サインアップ後に飛ばす先を指定
  def after_inactive_sign_up_path_for(resource)
    flash[:notice] = "まだ登録は完了していません。認証リンクを確認し登録を完了してください"
    thanks_path
  end
end
