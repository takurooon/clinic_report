class Admin::ApplicationController < ActionController::Base
  before_action :if_not_admin

  @reports = Report.all.includes(:user, :clinic)
  @users = User.all.includes(:reports)
  @clinics = Clinic.all.includes(:reports)

  private
  def if_not_admin
    redirect_to root_path unless current_user && current_user.admin.present?
  end
end