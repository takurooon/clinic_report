class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @report = @comment.report
    @comment.user_id = current_user.id
    if @comment.save
      @report.create_notification_comment!(current_user, @comment.id)
      redirect_to @comment.report, flash: {notice: 'コメントを投稿しました'}
    else
      flash[:alert] = comment.errors.full_messages
      redirect_back(fallback_location: comment.report)
    end
  end


  def destroy
    comment = Comment.find(params[:id])
    if comment.user != current_user
      redirect_to report_path, alert: '削除権限がありません' 
      return
    end
    comment.delete
    redirect_to comment.report, flash: { notice: "コメントが削除されました" }
  end

  private
    def comment_params
      params.require(:comment).permit(:report_id, :comment)
    end
end
