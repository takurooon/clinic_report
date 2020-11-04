class ClinicsController < ApplicationController

  def index
    @clinics = Clinic.all
    @prefecture = Prefecture.where(id: 1..47)
    @all_clinics = Clinic.all.order(prefecture_id: :asc, city_id: :asc)
    @list = {}
    Clinic.joins(city: :prefecture).includes(:city, :prefecture).each do |clinic| 
      if @list[clinic.prefecture.id].nil?
        @list[clinic.prefecture.id] = {
          id: clinic.prefecture.id,
          name: clinic.prefecture.name,
          cities: {}
        }
      end
      if @list[clinic.prefecture.id][:cities][clinic.city.id].nil?
        @list[clinic.prefecture.id][:cities][clinic.city.id] = {
          name: clinic.city.name,
          clinics: []
        }
      end
      @list[clinic.prefecture.id][:cities][clinic.city.id][:clinics] << {
        id: clinic.id,
        name: clinic.name,
        yomigana: clinic.yomigana
      }
    end
  end

  def show
    @get_limit = 5
    @clinic = Clinic.find(params[:id])
    clinic_reports = Report.where(clinic_id: @clinic, status: 0)
    @clinic_reports = clinic_reports.limit(@get_limit).order(created_at: :desc)
    @clinic_reports_count = Report.where(clinic_id: @clinic, status: 0).count

    @doctor_quality = clinic_reports.average(:doctor_quality).to_f
    @staff_quality = clinic_reports.average(:staff_quality).to_f
    @impression_of_technology = clinic_reports.average(:impression_of_technology).to_f
    @impression_of_price = clinic_reports.average(:impression_of_price).to_f
    @average_waiting_time2 = clinic_reports.average(:average_waiting_time2).to_f
    @comfort_of_space = clinic_reports.average(:comfort_of_space).to_f
    @average_score = ((@doctor_quality + @staff_quality + @impression_of_technology + @impression_of_price + @average_waiting_time2 + @comfort_of_space)/6.to_f).round(1)
    gon.clinic_name = @clinic.name
    gon.clinic_evaluation = []
    gon.clinic_evaluation << @doctor_quality << @staff_quality << @impression_of_technology << @impression_of_price << @average_waiting_time2 << @comfort_of_space
    @clinic_evaluation = gon.clinic_evaluation.compact
  end

end