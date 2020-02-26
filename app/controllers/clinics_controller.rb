class ClinicsController < ApplicationController

  def cities_select
      @cities = City.where(prefecture_id: params[:prefecture_id]).order(:id).joins(:clinics).distinct
      render partial: 'address/cities'
  end

  def clinics_select
      @clinics = Clinic.where(city_id: params[:city_id])
      render partial: 'address/clinics'
  end

  def index
  end
end