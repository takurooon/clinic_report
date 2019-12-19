class MyPageController < ApplicationController
  def index
    @user = current_user
    @published_reports = Report.published.order("created_at DESC").page(params[:page]).per(10)
    @draft_reports = @user.reports.draft.order("created_at DESC").page(params[:page]).per(10)
    @like_reports = @user.like_reports
  end
end
