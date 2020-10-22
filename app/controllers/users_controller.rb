class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @reports = @user.reports.order("created_at DESC").page(params[:page]).per(10)
    # @like_reports = @user.like_reports
  end

  def thanks
  end

  def destroy
    @user = User.find(params[:id]) #特定のidを持つ情報を取得
    @user.destroy
    flash[:notice] = "退会処理が完了しました。ご利用ありがとうございました。またのご利用を心よりお待ちしております。"
    redirect_to :root #削除に成功すればrootページに戻る
  end
end