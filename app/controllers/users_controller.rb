class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @reports = @user.reports
    # @like_reports = @user.like_reports
  end

  def thanks
  end
end