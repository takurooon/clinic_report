class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def may_page
    @user = current_user
    @published_reports = @user.reports.released.order("created_at DESC").page(params[:page]).per(10)
    @draft_reports = @user.reports.nonreleased.order("created_at DESC").page(params[:page]).per(10)
    # @like_reports = @user.like_reports
  end

  def show
    @user = User.find(params[:id])
    @reports = @user.reports
    # @like_reports = @user.like_reports
  end

  def thanks
  end
end