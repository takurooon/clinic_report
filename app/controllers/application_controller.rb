class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :store_current_location, unless: :devise_or_thanks_action?

  protected

  def configure_permitted_parameters
    added_attrs = [:name, :gender, :icon, :link, :self_introduction, :birthday, :provider, :uid, :username]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  # registration_controllerのbefore_actionで必要か？
  # def configure_account_update_params
  #   added_attrs = [:name, :gender, :icon, :link, :self_introduction, :birthday, :provider, :uid, :username]
  #   devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  # end

  def store_current_location
    store_location_for(:user, request.url)
  end

  def devise_or_thanks_action?
    devise_controller? || action_name == 'thanks'
  end
end
