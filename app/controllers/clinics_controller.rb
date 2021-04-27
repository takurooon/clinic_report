class ClinicsController < ApplicationController

  def index
    # @clinics = Clinic.all
    # @prefecture = Prefecture.where(id: 1..47)
    # @all_clinics = Clinic.all.order(prefecture_id: :asc, city_id: :asc)
    report_count = Report.group(:clinic_id).where.not(status: 1).size
    @all_clinics_count = Clinic.count.to_s(:delimited)
    @ivf_clinics_count = Clinic.where(ivf: 1).count.to_s(:delimited)
    binding.pry
    @list = {}
    Clinic.joins(city: :prefecture).includes(:city, :prefecture).order(:prefecture_id, :city_id).each do |clinic|
      if @list[clinic.prefecture.id].nil?
        @list[clinic.prefecture.id] = {
          id: clinic.prefecture.id,
          name: clinic.prefecture.name,
          name_alphabet: clinic.prefecture.name_alphabet,
          cities: {}
        }
      end
      if @list[clinic.prefecture.id][:cities][clinic.city.id].nil?
        @list[clinic.prefecture.id][:cities][clinic.city.id] = {
          name: clinic.city.name,
          name_alphabet: clinic.city.name_alphabet,
          clinics: [],
          ivf_clinics: []
        }
      end
      @list[clinic.prefecture.id][:cities][clinic.city.id][:clinics] << {
        id: clinic.id,
        name: clinic.name,
        yomigana: clinic.yomigana,
        count: report_count[clinic.id]
      }
    end
    @list_ivf = {}
    Clinic.joins(city: :prefecture).includes(:city, :prefecture).where(ivf: 1).order(:prefecture_id, :city_id).each do |clinic|
      if @list_ivf[clinic.prefecture.id].nil?
        @list_ivf[clinic.prefecture.id] = {
          id: clinic.prefecture.id,
          name: clinic.prefecture.name,
          name_alphabet: clinic.prefecture.name_alphabet,
          cities: {}
        }
      end
      if @list_ivf[clinic.prefecture.id][:cities][clinic.city.id].nil?
        @list_ivf[clinic.prefecture.id][:cities][clinic.city.id] = {
          name: clinic.city.name,
          name_alphabet: clinic.city.name_alphabet,
          clinics: [],
          ivf_clinics: []
        }
      end
      @list_ivf[clinic.prefecture.id][:cities][clinic.city.id][:clinics] << {
        id: clinic.id,
        name: clinic.name,
        yomigana: clinic.yomigana,
        count: report_count[clinic.id]
      }
    end
  end

  def prefecture
    @prefecture = Prefecture.find_by(name_alphabet: params[:prefecture])
    # cities = City.where(prefecture_id: @prefecture)
    # clinics = Clinic.where(city_id: cities.ids)
    clinics = Clinic.where(prefecture_id: @prefecture)
    @prefecture_clinics = Clinic.where(prefecture_id: @prefecture).name_yomigana
    @reports = Report.where(clinic_id: clinics.ids, status: 0).order(created_at: :desc)
    @clinic_all_reports = Report.where(clinic_id: clinics.ids, status: 0).count
    @rereased_reports = Clinic.joins(:reports).where(city_id: @prefecture.id, reports: {status: 0})
  end

  def city
    prefecture = Prefecture.find_by(name_alphabet: params[:prefecture])
    @city = City.find_by(prefecture_id: prefecture.id, name_alphabet: params[:value])
    clinics = Clinic.where(city_id: @city.id)
    @city_clinics = Clinic.where(city_id: @city.id).name_yomigana
    @reports = Report.where(clinic_id: clinics.ids, status: 0).order(created_at: :desc)
    @clinic_all_reports = Report.where(clinic_id: clinics.ids, status: 0).count
    @rereased_reports = Clinic.joins(:reports).where(city_id: @city.id, reports: {status: 0})
  end

  def show
    @get_limit = 5
    @clinic = Clinic.find(params[:id])
    clinic_reports = Report.where(clinic_id: @clinic.id, status: 0)
    @clinic_reports = clinic_reports.limit(@get_limit).order(created_at: :desc)
    @clinic_reports_count = Report.where(clinic_id: @clinic.id, status: 0).count

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

  def clinic_report
    @clinics = Clinic.find_by(id: params[:value])
    @reports = Report.where(clinic_id: @clinics.id, status: 0)
    @clinic_reports = Report.where(activated: true).search(params[:search]).order(created_at: :desc)
    @transfer_reports = Report.joins(:itinerary_of_choosing_a_clinics).where(status: 0, itinerary_of_choosing_a_clinics: {clinic_id: @clinics.id, public_status: "show"}).distinct
    @clinic_reports_count = Report.where(clinic_id: @clinics.id, status: 0).count
  end
end