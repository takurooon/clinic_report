class SearchesController < ApplicationController

  def search
  end

  def all_amh
    amhs = Report::HASH_AMH_SEARCH
    reports = Report.group(:amh).where.not(amh: nil).distinct.count
    c = amhs.keys - reports.keys
    c.each do |d|
      amhs.delete(d)
    end
    @amhs = amhs
  end

  def amh
    amh = Report::HASH_AMH_SEARCH
    amh_value = params[:value].to_i
    @selected_amh = amh[amh_value]
    @reports = Report.where(amh: amh_value, status: 0).order(created_at: :desc)
    @amh_page = Report.page(params[:page]).per(10)
  end

  def all_status
    statuses = Report::HASH_CURRENT_STATE_SEARCH
    reports = Report.group(:current_state).where.not(current_state: nil).distinct.count
    s = statuses.keys - reports.keys
    s.each do |t|
      statuses.delete(t)
    end
    @status = statuses
  end

  def status
    status = Report::HASH_CURRENT_STATE_SEARCH
    status_value = params[:value].to_i
    @selected_status = status[status_value]
    @reports = Report.where(current_state: status_value, status: 0).order(created_at: :desc)
    @status_page = Report.page(params[:page]).per(10)
  end

  def clinics
    @clinics = Clinic.all
  end

  def clinics_area
    @clinics = Clinic.all
  end

  def clinic
    @clinics = Clinic.find_by(id: params[:value])
    @reports = Report.where(clinic_id: @clinics.id, status: 0)
    @clinic_reports = Report.where(activated: true).search(params[:search]).order(created_at: :desc)
  end

  def clinic_prefecture
    @prefecture = Prefecture.find_by(name: params[:value])
    # cities = City.where(prefecture_id: @prefecture)
    # clinics = Clinic.where(city_id: cities.ids)
    clinics = Clinic.where(prefecture_id: @prefecture)
    @reports = Report.where(clinic_id: clinics.ids, status: 0).order(created_at: :desc)
  end
  
  def clinic_city
    @city = City.find_by(name: params[:value])
    clinics = Clinic.where(city_id: @city.id)
    @reports = Report.where(clinic_id: clinics.ids, status: 0).order(created_at: :desc)
  end

  def clinic_prefecture_area
    @prefecture = Prefecture.find_by(name: params[:value])
    clinics = Clinic.where(prefecture_id: @prefecture)
    @reports = Report.where(clinic_id: clinics.ids, status: 0).order(created_at: :desc)
  end
  
  def clinic_city_area
    @city = City.find_by(name: params[:value])
    clinics = Clinic.where(city_id: @city.id)
    @reports = Report.where(clinic_id: clinics.ids, status: 0).order(created_at: :desc)
  end

  def all_age
    age = Report::HASH_TREATMENT_END_AGE_SEARCH
    reports = Report.group(:treatment_end_age).where.not(treatment_end_age: nil).distinct.count
    c = age.keys - reports.keys
    c.each do |d|
      age.delete(d)
    end
    @age = age

    @age_range = { "~19": "19歳以下", "20~24": "20〜24歳", "25~29": "25〜29歳", "30~34": "30〜34歳", "35~39": "35〜39歳", "40~44": "40〜44歳", "45~": "45歳以上" }
  end

  def age
    age = Report::HASH_TREATMENT_END_AGE_SEARCH
    if params[:value] === "45~歳"
      value = "4500"
      age_45 = "45歳以上"
    else
      value = params[:value]
    end
    age_value = value.delete("^0-9")

    case age_value.to_i
    when 2024
      @selected_age = "20〜24歳"
    when 2529
      @selected_age = "25〜29歳"
    when 3034
      @selected_age = "30〜34歳"
    when 3539
      @selected_age = "35〜39歳"
    when 4044
      @selected_age = "40〜44歳"
    when 4044
      @selected_age = "40〜44歳"
    when 4500
      @selected_age = age_45
    when 19
      @selected_age = age_value.to_s + "歳以下"
    when 20..59
      @selected_age = age_value.to_s + "歳"
    when 60
      @selected_age = age_value.to_s + "歳以上"
    else
      @selected_age = "不明"
    end

    if age_value.length > 3
      i = age_value.scan(/.{2}/)
      a = i[0]
      b = i[1]
      @reports = Report.where(treatment_end_age: a..b, status: 0).order(created_at: :desc)
    else
      @reports = Report.where(treatment_end_age: age_value, status: 0).order(created_at: :desc)
    end
  end

  def tags
    report_f_diseases = ReportFDisease.group(:f_disease_id).where.not(f_disease_id: nil).distinct.count
    f_disease = report_f_diseases.keys
    @f_diseases = FDisease.where(id: f_disease).name_yomigana

    report_m_diseases = ReportMDisease.group(:m_disease_id).where.not(m_disease_id: nil).distinct.count
    m_disease = report_m_diseases.keys
    @m_diseases = MDisease.where(id: m_disease).name_yomigana

    report_fuiku_inspections = ReportFuikuInspection.group(:fuiku_inspection_id).where.not(fuiku_inspection_id: nil).distinct.count
    fuiku_inspection = report_fuiku_inspections.keys
    @fuiku_inspections = FuikuInspection.where(id: fuiku_inspection).name_yomigana

    report_f_surgeries = ReportFSurgery.group(:f_surgery_id).where.not(f_surgery_id: nil).distinct.count
    f_surgery = report_f_surgeries.keys
    @f_surgeries = FSurgery.where(id: f_surgery).name_yomigana

    report_m_surgery = ReportMSurgery.group(:m_surgery_id).where.not(m_surgery_id: nil).distinct.count
    m_surgery = report_m_surgery.keys
    @m_surgeries = MSurgery.where(id: m_surgery).name_yomigana
  end

  def tag
    if params[:gender] === "女性"
      if params[:tags] === "疾患"
        @tag = FDisease.find_by(name: params[:value])
        @reports = @tag.reports.order(created_at: :desc)
      elsif params[:tags] === "手術"
        @tag = FSurgery.find_by(name: params[:value])
        @reports = @tag.reports.order(created_at: :desc)
      else params[:tags] === "不育症"
        @tag = FuikuInspection.find_by(name: params[:value])
        @reports = @tag.reports.order(created_at: :desc)
      end
    else
      if params[:tags] === "疾患"
        @tag = MDisease.find_by(name: params[:value])
        @reports = @tag.reports.order(created_at: :desc)
      else params[:tags] === "手術"
        @tag = MSurgery.find_by(name: params[:value])
        @reports = @tag.reports.order(created_at: :desc)
      end
    end
  end

  def all_area
  end

  def area_prefecture
    @prefecture = Prefecture.find_by(name: params[:value])
    @reports = Report.where(prefecture_id: @prefecture.id, status: 0, prefecture_at_the_time_status: 0).order(created_at: :desc)
    # @reports = Report.joins(clinic: :prefecture).where(prefectures: {id: @prefecture.id}).where("(status = ?)", 0) エリアからクリニックのレポコ検索
  end

  def area_city
    @city = City.find_by(name: params[:value])
    @reports = Report.where(city_id: @city.id, status: 0, city_at_the_time_status: 0).order(created_at: :desc)
    # @reports = Report.joins(clinic: :city).where(cities: {id: @city.id}).where("(status = ?)", 0) エリアからクリニックのレポコ検索
  end
end