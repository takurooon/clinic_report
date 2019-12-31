class ClinicsController < ApplicationController

  def cities_select
    # if request.xhr?
      @cities = City.where(prefecture_id: params[:prefecture_id]).order(:id).joins(:clinics).distinct
      render partial: 'address/cities'
    # end
  end

  def clinics_select
    # if request.xhr?
      render partial: 'address/clinics', locals: { city_id: params[:city_id] }
    # end
  end
end