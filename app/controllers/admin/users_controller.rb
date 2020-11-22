class Admin::UsersController < Admin::ApplicationController
  def show
    @user = User.find(params[:id])
    @reports = @user.reports.order("created_at DESC").page(params[:page]).per(10)
  end
end