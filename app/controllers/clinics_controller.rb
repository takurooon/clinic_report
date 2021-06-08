class ClinicsController < ApplicationController

  def index
    # @clinics = Clinic.all
    # @prefecture = Prefecture.where(id: 1..47)
    # @all_clinics = Clinic.all.order(prefecture_id: :asc, city_id: :asc)
    report_count = Report.group(:clinic_id).where.not(status: 1).size
    @all_clinics_count = Clinic.count.to_s(:delimited)
    @ivf_clinics_count = Clinic.where(ivf: 1).count.to_s(:delimited)
    @pgt_clinics_count = Clinic.where(pgt: 1).count.to_s(:delimited)
    @list = {}
    Clinic.includes(:city, :prefecture).order(:prefecture_id, :city_id).each do |clinic|
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
    Clinic.includes(:city, :prefecture).where(ivf: 1).order(:prefecture_id, :city_id).each do |clinic|
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
        }
      end
      @list_ivf[clinic.prefecture.id][:cities][clinic.city.id][:clinics] << {
        id: clinic.id,
        name: clinic.name,
        yomigana: clinic.yomigana,
        count: report_count[clinic.id]
      }
    end
    @list_pgt = {}
    Clinic.joins(city: :prefecture).includes(:city, :prefecture).where(pgt: 1).order(:prefecture_id, :city_id).each do |clinic|
      if @list_pgt[clinic.prefecture.id].nil?
        @list_pgt[clinic.prefecture.id] = {
          id: clinic.prefecture.id,
          name: clinic.prefecture.name,
          name_alphabet: clinic.prefecture.name_alphabet,
          cities: {}
        }
      end
      if @list_pgt[clinic.prefecture.id][:cities][clinic.city.id].nil?
        @list_pgt[clinic.prefecture.id][:cities][clinic.city.id] = {
          name: clinic.city.name,
          name_alphabet: clinic.city.name_alphabet,
          clinics: [],
        }
      end
      @list_pgt[clinic.prefecture.id][:cities][clinic.city.id][:clinics] << {
        id: clinic.id,
        name: clinic.name,
        yomigana: clinic.yomigana,
        count: report_count[clinic.id]
      }
    end
  end

  def prefecture
    @prefecture = Prefecture.find_by(name_alphabet: params[:prefecture])
    clinics = Clinic.where(prefecture_id: @prefecture)
    report_count = Report.group(:clinic_id).where.not(status: 1).size
    @list = {}
    Clinic.where(prefecture_id: @prefecture).each do |clinic|
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
        }
      end
      @list[clinic.prefecture.id][:cities][clinic.city.id][:clinics] << {
        id: clinic.id,
        name: clinic.name,
        yomigana: clinic.yomigana,
        count: report_count[clinic.id]
      }
    end
    @reports = Report.released.includes([:user, user: { icon_attachment: :blob }, city: :prefecture, clinic: [city: :prefecture]]).where(clinic_id: clinics.ids).order("created_at DESC").page(params[:page]).per(20).with_rich_text_content
    @like_count = Like.group(:report_id).size
  end

  def city
    prefecture = Prefecture.find_by(name_alphabet: params[:prefecture])
    @city = City.find_by(prefecture_id: prefecture.id, name_alphabet: params[:value])
    clinics = Clinic.where(city_id: @city.id)
    @city_clinics = Clinic.where(city_id: @city.id).name_yomigana
    @reports = Report.released.includes([:user, user: { icon_attachment: :blob }, city: :prefecture, clinic: [city: :prefecture]]).where(clinic_id: clinics.ids).order("created_at DESC").page(params[:page]).per(20).with_rich_text_content
    @like_count = Like.group(:report_id).size
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

    current_state = clinic_reports.pluck(:current_state).compact
    @current_state_frequent = current_state.max_by{|value| current_state.count(value)}
    @current_state_frequent_2 = current_state.group_by { |e| e }.sort_by { |e, v| -v.size }.map(&:first).second
    @current_state_frequent_3 = current_state.group_by { |e| e }.sort_by { |e, v| -v.size }.map(&:first).third
  end

  def clinic_report
    @clinic = Clinic.find_by(id: params[:value])
    @reports = Report.where(clinic_id: @clinic.id, status: 0).page(params[:page]).per(20)
    # @clinic_reports = Report.where(activated: true).search(params[:search]).order(created_at: :desc)
    @transfer_reports = Report.joins(:itinerary_of_choosing_a_clinics).where(status: 0, itinerary_of_choosing_a_clinics: {clinic_id: @clinic.id, public_status: "show"}).distinct
    @clinic_reports_count = Report.where(clinic_id: @clinic.id, status: 0).size
    @like_count = Like.group(:report_id).size
  end

  def search_cl
    @keyword = params[:keyword]
    @clinics = Clinic.search_cl(params[:keyword]).pluck(:id)
    reports = Report.where(clinic_id: @clinics, status: 0)
    @reports = reports.page(params[:page]).per(20)
    @clinic_reports_count = Report.where(clinic_id: @clinics, status: 0).size
    @like_count = Like.group(:report_id).size
  end
end