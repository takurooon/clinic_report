class MyPageController < ApplicationController
  def index
    @user = current_user
    @reports = @user.reports
    @like_reports = @user.like_reports
  end
end
