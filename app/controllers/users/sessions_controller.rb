# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  protect_from_forgery with: :exception
  before_action :reject_user, only: [:create]
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # ゲストログイン機能(参考: https://qiita.com/take18k_tech/items/35f9b5883f5be4c6e104)
  # def new_guest
  #   user = User.guest
  #   sign_in user
  #   redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  # end
  # ここまで(ゲストログイン機能)

  # POST /resource/sign_in
  # ログイン失敗後は def failed に飛ぶように変更
  def create
    auth_options = { scope: resource_name, recall: "#{controller_path}#failed" }
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # ログイン失敗の時は直前のURLにリダイレクトする
  def failed
    flash[:alert] = "メールアドレスまたはパスワードが違います。"
    redirect_to params[:user][:url]
  end

  # protected

  # ログイン後に飛ばす先を指定
  def after_sign_in_path_for(resource)
    flash[:notice] = "ログインしました"
    stored_location_for(resource) || root_path
  end

  # ログアウト後に飛ばす先を指定
  def after_sign_out_path_for(resource)
    flash[:notice] = "ログアウトしました"
    root_path
  end
  
  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end


  # 参考記事(https://qiita.com/yuto_1014/items/358d0a425193b12c969a)
  protected

  def reject_user
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user
      if (@user.valid_password?(params[:user][:password]) && (@user.active_for_authentication? == false))
        flash[:alert] = "退会済みです。"
        redirect_to new_user_session_path
      end
    else
      flash[:alert] = "必須項目を入力してください。"
    end
  end
end
