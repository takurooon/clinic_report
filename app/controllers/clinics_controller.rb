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

  def city
    @city = City.find_by(name: params[:city])
    @clinics = Clinic.where(city_id: @city.id).name_yomigana
    @reports = Report.where(clinic_id: @clinics.ids, status: 0).order(created_at: :desc)
    @clinic_all_reports = Report.where(clinic_id: @clinics.ids, status: 0).count
    @rereased_reports = Clinic.joins(:reports).where(city_id: @city.id, reports: {status: 0})
  end

  def show
    @get_limit = 5
    @clinic = Clinic.find(params[:id])
    clinic_reports = Report.where(clinic_id: @clinic, status: 0)
    @clinic_reports = clinic_reports.limit(@get_limit).order(created_at: :desc)
    @clinic_reports_count = Report.where(clinic_id: @clinic, status: 0).count

    unless clinic_reports.average(:doctor_quality).blank?
      @doctor_quality = clinic_reports.average(:doctor_quality).round(1)
    else
      @doctor_quality = 0
    end
    unless clinic_reports.average(:staff_quality).blank?
      @staff_quality = clinic_reports.average(:staff_quality).round(1)
    else
      @staff_quality = 0
    end
    unless clinic_reports.average(:impression_of_technology).blank?
      @impression_of_technology = clinic_reports.average(:impression_of_technology).round(1)
    else
      @impression_of_technology = 0
    end
    unless clinic_reports.average(:impression_of_price).blank?
      @impression_of_price = clinic_reports.average(:impression_of_price).round(1)
    else
      @impression_of_price = 0
    end
    unless clinic_reports.average(:average_waiting_time2).blank?
      @average_waiting_time2 = clinic_reports.average(:average_waiting_time2).round(1)
    else
      @average_waiting_time2 = 0
    end
    unless clinic_reports.average(:comfort_of_space).blank?
      @comfort_of_space = clinic_reports.average(:comfort_of_space).round(1)
    else
      @comfort_of_space = 0
    end
    @average_score = ((@doctor_quality + @staff_quality + @impression_of_technology + @impression_of_price + @average_waiting_time2 + @comfort_of_space)/6).round(1)
    gon.clinic_name = @clinic.name
    gon.clinic_evaluation = []
    gon.clinic_evaluation << @doctor_quality << @staff_quality << @impression_of_technology << @impression_of_price << @average_waiting_time2 << @comfort_of_space
    @clinic_evaluation = gon.clinic_evaluation.compact
  end
end