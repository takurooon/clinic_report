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
    @clinic = Clinic.find(params[:id])
    @clinic_reports = Report.where(clinic_id: @clinic, status: 0).limit(5).order(created_at: :desc)
    @clinic_reports.each do |report|
      if report.doctor_quality.present? || report.staff_quality.present? || report.impression_of_price.present? || report.impression_of_technology.present? || report.average_waiting_time2.present?|| report.comfort_of_space.present?
        @rating = (report.doctor_quality + report.staff_quality + report.impression_of_price + report.impression_of_technology + report.average_waiting_time2 + report.comfort_of_space) / 6.to_f
      else
        @rating = nil
      end
    end
  end

end