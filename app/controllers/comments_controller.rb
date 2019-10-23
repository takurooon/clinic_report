class CommentsController < ApplicationController
  def create
    comment = Comment.new(comment_params)
    if comment.save
      flash[:notice] = 'コメントを投稿しました'
      redirect_to comment.report
    else
      flash[:comment] = comment
      flash[:error_messages] = comment.errors.full_messages
      redirect_back fallback_location: comment.report
    end
  end

  def destroy
  end

  private
    def comment_params
      params.require(:comment).permit(:report_id, :user_id, :comment)
    end
end
