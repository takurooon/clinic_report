class LikesController < ApplicationController
  def create
    @report = Report.find(params[:report_id])
    @like = current_user.likes.create(report_id: params[:report_id])
    @report.create_notification_like!(current_user)
  end

  def destroy
    @report = Report.find(params[:report_id])
    @like = Like.find_by(report_id: params[:report_id], user_id: current_user.id)
    @like.destroy
  end
end
