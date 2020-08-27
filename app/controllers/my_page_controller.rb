class MyPageController < ApplicationController
  def index
    @user = current_user
    @published_reports = @user.reports.released.order("created_at DESC").page(params[:page]).per(10)
    @draft_reports = @user.reports.nonreleased.order("created_at DESC").page(params[:page]).per(10)
    # @like_reports = @user.like_reports

    @registration_alert1 = @user.registration_status1
    @registration_alert2 = @user.registration_status2
  end

  def thanks
  end
end
