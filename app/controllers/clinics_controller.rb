class ClinicsController < ApplicationController

  def cities_select
    # if request.xhr?
      render partial: 'address/cities', locals: { prefecture_id: params[:prefecture_id] }
    # end
  end

  def clinics_select
    # if request.xhr?
      render partial: 'address/clinics', locals: { city_id: params[:city_id] }
    # end
  end
end
