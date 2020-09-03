class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :store_current_location, unless: :devise_or_thanks_action?

  protected

  def configure_permitted_parameters
    added_attrs = [:name, :gender, :link, :self_introduction, :birthday, :provider, :uid, :username, :icon, :all_number_of_sairan, :all_number_of_transplants, :all_cost, :first_age_to_start, :first_age_to_start_art, :number_of_aih, :number_of_chemical_abortions, :number_of_chemical_abortions_status, :number_of_early_miscarriages, :number_of_early_miscarriages_status, :number_of_late_miscarriages, :number_of_late_miscarriages_status, :number_of_times_the_grant_was_received, :all_grant_amount]
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

  def about
  end

  def terms
  end

  def privacy
  end

  def repoco
  end
end
