class ClinicsController < ApplicationController

  def cities_select_clinics
    # クリニックが存在するcityだけを抽出
    @cities = City.where(prefecture_id: params[:prefecture_id]).order(:id).joins(:clinics).distinct
    render partial: 'address/cities'
  end

  def cities_select_area
    # 住まい検索
    @cities = City.where(prefecture_id: params[:prefecture_id])
    render partial: 'address/cities'
  end

  def clinics_select
    city = City.find_by(name: params[:city_name])
    @clinics = Clinic.where(city_id: city.id)
    render partial: 'address/clinics'
  end

  def clinic_select
    @clinics = Clinic.where(prefecture_id: params[:prefecture_id])
    render partial: 'address/clinics'
  end

  def index
  end
end