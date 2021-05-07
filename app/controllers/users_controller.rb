class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @reports = @user.reports.released.order("created_at DESC").page(params[:page]).per(10)
    @like_count = Like.group(:report_id).size
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

  # search_controllerから移動
  def all_area
  end

  def cities_select_area
    # 住まい検索
    @cities = City.where(prefecture_id: params[:prefecture_id]).order(:id)
    # ある程度レポコが溜まってきたら上を止め、下のコードを有効にする(レポコ投稿者のいない市区町村は表示しない仕様)
    # @cities = City.where(prefecture_id: params[:prefecture_id]).order(:id).joins(:reports).distinct
    render partial: 'address/cities'
  end

  def area_prefecture
    @prefecture = Prefecture.find_by(name_alphabet: params[:prefecture])
    @reports = Report.where(prefecture_id: @prefecture.id, status: 0, prefecture_at_the_time_status: 0).order(created_at: :desc)
    @clinic_all_reports = @reports.size
    @like_count = Like.group(:report_id).size
    # @reports = Report.joins(clinic: :prefecture).where(prefectures: {id: @prefecture.id}).where("(status = ?)", 0) エリアからクリニックのレポコ検索
  end

  def area_city
    prefecture = Prefecture.find_by(name_alphabet: params[:prefecture])
    @city = City.find_by(prefecture_id: prefecture.id, name_alphabet: params[:city])
    @reports = Report.where(city_id: @city.id, status: 0, city_at_the_time_status: 0).order(created_at: :desc)
    @clinic_all_reports = @reports.size
    @like_count = Like.group(:report_id).size
    # @reports = Report.joins(clinic: :city).where(cities: {id: @city.id}).where("(status = ?)", 0) エリアからクリニックのレポコ検索
  end
  # ここまで
end