class MyPageController < ApplicationController
  def index
    @user = current_user
    @published_reports = Report.released.order("created_at DESC").page(params[:page]).per(10)
    @draft_reports = @user.reports.nonreleased.order("created_at DESC").page(params[:page]).per(10)
    @like_reports = @user.like_reports
  end

  def thanks
  end
end
