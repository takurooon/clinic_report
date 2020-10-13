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
    current_statuses = Report::HASH_CURRENT_STATE_SEARCH
    current_state_reports = Report.group(:current_state).where.not(current_state: nil).distinct.count
    c = current_statuses.keys - current_state_reports.keys
    c.each do |s|
      current_statuses.delete(s)
    end
    @current_status = current_statuses

    fertility_treatment_number = Report::HASH_FERTILITY_TREATMENT_NUMBER_SEARCH
    fertility_treatment_number_reports = Report.group(:fertility_treatment_number).where.not(fertility_treatment_number: nil).distinct.count
    f = fertility_treatment_number.keys - fertility_treatment_number_reports.keys
    f.each do |t|
      fertility_treatment_number.delete(t)
    end
    @fertility_treatment_number = fertility_treatment_number
  end

  def status
    if params[:value].include?("current_state")
      status = Report::HASH_CURRENT_STATE_SEARCH
      status_value = params[:value].to_i
      @selected_word = status[status_value]
      @reports = Report.where(current_state: status_value, status: 0).order(created_at: :desc)
      @selected_word_page = Report.page(params[:page]).per(10)
    else
      fertility_treatment_number = Report::HASH_FERTILITY_TREATMENT_NUMBER_SEARCH
      fertility_treatment_number_value = params[:value].to_i
      @selected_word = fertility_treatment_number[fertility_treatment_number_value]
      @reports = Report.where(fertility_treatment_number: fertility_treatment_number_value, status: 0).order(created_at: :desc)
      @selected_word_page = Report.page(params[:page]).per(10)
    end
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
    @transfer_reports = Report.joins(:itinerary_of_choosing_a_clinics).where(status: 0, itinerary_of_choosing_a_clinics: {clinic_id: @clinics.id}).distinct
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
    all_age = age.keys - reports.keys
    all_age.each do |aa|
      age.delete(aa)
    end
    @age = age

    @age_range = { "~19": "19歳以下", "20~24": "20〜24歳", "25~29": "25〜29歳", "30~34": "30〜34歳", "35~39": "35〜39歳", "40~44": "40〜44歳", "45~": "45歳以上" }
  end

  def age
    value = params[:value]
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
    when 45
      @selected_age = "45歳以上"
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

    report_f_examinations = ReportClFemaleInspection.group(:cl_female_inspection_id).where.not(cl_female_inspection_id: nil).distinct.count
    cl_female_examination = report_f_examinations.keys
    @cl_female_examinations = ClFemaleInspection.where(id: cl_female_examination).name_yomigana

    @special_examinations = SpecialInspection.where.not(report_id: nil).distinct

    report_m_examinations = ReportClMaleInspection.group(:cl_male_inspection_id).where.not(cl_male_inspection_id: nil).distinct.count
    cl_male_examination = report_m_examinations.keys
    @cl_male_examinations = ClMaleInspection.where(id: cl_male_examination).name_yomigana

    report_f_surgeries = ReportFSurgery.group(:f_surgery_id).where.not(f_surgery_id: nil).distinct.count
    f_surgery = report_f_surgeries.keys
    @f_surgeries = FSurgery.where(id: f_surgery).name_yomigana

    report_m_surgery = ReportMSurgery.group(:m_surgery_id).where.not(m_surgery_id: nil).distinct.count
    m_surgery = report_m_surgery.keys
    @m_surgeries = MSurgery.where(id: m_surgery).name_yomigana

    report_sairan_medicine = ReportSairanMedicine.group(:sairan_medicine_id).where.not(sairan_medicine_id: nil).distinct.count
    sairan_medicine = report_sairan_medicine.keys
    @sairan_medicines = SairanMedicine.where(id: sairan_medicine).name_yomigana

    report_transfer_medicine = ReportTransferMedicine.group(:transfer_medicine_id).where.not(transfer_medicine_id: nil).distinct.count
    transfer_medicine = report_transfer_medicine.keys
    @transfer_medicines = TransferMedicine.where(id: transfer_medicine).name_yomigana
  end

  def tag
    if params[:gender] === "女性"
      if params[:tags] === "疾患"
        @tag = FDisease.find_by(name: params[:value])
        @reports = @tag.reports.order(created_at: :desc)
      elsif params[:tags] === "手術"
        @tag = FSurgery.find_by(name: params[:value])
        @reports = @tag.reports.order(created_at: :desc)
      elsif params[:tags] === "基本検査"
        @tag = ClFemaleInspection.find_by(name: params[:value])
        @reports = @tag.reports.order(created_at: :desc)
      elsif params[:tags] === "特殊検査"
        @tag = SpecialInspection.find_by(name: params[:value])
        @reports = Report.joins(:special_inspections).where(special_inspections: { name: @tag.name })
      elsif params[:tags] === "不育症"
        @tag = FuikuInspection.find_by(name: params[:value])
        @reports = @tag.reports.order(created_at: :desc)
      elsif params[:tags] === "採卵周期の薬剤"
        @tag = SairanMedicine.find_by(name: params[:value])
        @reports = @tag.reports.order(created_at: :desc)
      else params[:tags] === "移植周期の薬剤"
        @tag = TransferMedicine.find_by(name: params[:value])
        @reports = @tag.reports.order(created_at: :desc)
      end
    else
      if params[:tags] === "疾患"
        @tag = MDisease.find_by(name: params[:value])
        @reports = @tag.reports.order(created_at: :desc)
      elsif params[:tags] === "手術"
        @tag = MSurgery.find_by(name: params[:value])
        @reports = @tag.reports.order(created_at: :desc)
      else params[:tags] === "基本検査"
        @tag = ClMaleInspection.find_by(name: params[:value])
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

  def works
    works = Report::HASH_WORK_STYLE_SEARCH
    reports = Report.group(:work_style).where.not(work_style: nil).distinct.count
    w = works.keys - reports.keys
    w.each do |wo|
      works.delete(wo)
    end
    @works = works

    industry = Report::HASH_INDUSTRY_TYPE_SEARCH
    reports = Report.group(:industry_type).where.not(industry_type: nil).distinct.count
    i = industry.keys - reports.keys
    i.each do |ind|
      industry.delete(ind)
    end
    @industry = industry
  end

  def work
    if params[:value].include?("work_style")
      work_style = Report::HASH_WORK_STYLE_SEARCH
      work_value = params[:value].to_i
      @selected_work = "「" + work_style[work_value] + "」"
      @reports = Report.where(work_style: work_value, status: 0).order(created_at: :desc)
      @work_page = Report.page(params[:page]).per(10)
    else
      industry_type = Report::HASH_INDUSTRY_TYPE_SEARCH
      industry_type_value = params[:value].to_i
      @selected_work = "「" + industry_type[industry_type_value] + "」" + "業界で働く方"
      @reports = Report.where(industry_type: industry_type_value, status: 0).order(created_at: :desc)
      @work_page = Report.page(params[:page]).per(10)
    end
  end

  def various_costs
    total_costs = Report::HASH_COST_SEARCH
    reports = Report.group(:cost).where.not(cost: nil).distinct.count
    v_cost = total_costs.keys - reports.keys
    v_cost.each do |vc|
      total_costs.delete(vc)
    end
    @total_costs = total_costs

    @total_costs_range = { "1~5": "50万円未満", "6~10": "50万円以上〜100万円未満", "11~20": "100万円以上〜200万円未満", "21~30": "200万円以上〜300万円未満", "31~40": "300万円以上〜400万円未満", "41~50": "400万円以上〜500万円未満", "51~60": "500万円以上〜600万円未満", "61~70": "600万円以上〜700万円未満", "71~80": "700万円以上〜800万円未満", "81~90": "800万円以上〜900万円未満", "91~100": "900万円以上〜1,000万円未満", "101000~": "1,000万円以上(または不明)" }

    sairan_cost = Report::HASH_SAIRAN_COST_SEARCH
    reports = Report.group(:sairan_cost).where.not(sairan_cost: nil).distinct.count
    sairan = sairan_cost.keys - reports.keys
    sairan.each do |sc|
      sairan_cost.delete(sc)
    end
    @sairan_cost = sairan_cost

    ishoku_cost = Report::HASH_ISHOKU_COST_SEARCH
    reports = Report.group(:ishoku_cost).where.not(ishoku_cost: nil).distinct.count
    ishoku = ishoku_cost.keys - reports.keys
    ishoku.each do |ic|
      ishoku_cost.delete(ic)
    end
    @ishoku_cost = ishoku_cost
  end

  def cost
    if params[:value].include?("cost")
      cost = Report::HASH_COST_SEARCH
      cost_value = params[:value].to_i
      @selected_cost = "治療費用「" + cost[cost_value] + "」"
      @reports = Report.where(cost: cost_value, status: 0).order(created_at: :desc)
      @cost_page = Report.page(params[:page]).per(10)
    elsif params[:value].include?("sairan")
      sairan_cost = Report::HASH_SAIRAN_COST_SEARCH
      sairan_cost_value = params[:value].to_i
      @selected_cost = "採卵1回あたりの費用「" + sairan_cost[sairan_cost_value] + "」"
      @reports = Report.where(sairan_cost: sairan_cost_value, status: 0).order(created_at: :desc)
      @cost_page = Report.page(params[:page]).per(10)
    elsif params[:value].include?("ishoku")
      ishoku_cost = Report::HASH_ISHOKU_COST_SEARCH
      ishoku_cost_value = params[:value].to_i
      @selected_cost = "移植1回あたりの費用「" + ishoku_cost[ishoku_cost_value] + "」"
      @reports = Report.where(ishoku_cost: ishoku_cost_value, status: 0).order(created_at: :desc)
      @cost_page = Report.page(params[:page]).per(10)
    else
      value = params[:value]
      cost_value = value.delete("^0-9")
      case cost_value.to_i
      when 15
        @selected_cost = "治療費用「50万円未満」"
      when 610
        @selected_cost = "治療費用「50万円以上〜100万円未満」"
      when 1120
        @selected_cost = "治療費用「100万円以上〜200万円未満」"
      when 2130
        @selected_cost = "治療費用「200万円以上〜300万円未満」"
      when 3140
        @selected_cost = "治療費用「300万円以上〜400万円未満」"
      when 4150
        @selected_cost = "治療費用「400万円以上〜500万円未満」"
      when 5160
        @selected_cost = "治療費用「500万円以上〜600万円未満」"
      when 6170
        @selected_cost = "治療費用「600万円以上〜700万円未満」"
      when 7180
        @selected_cost = "治療費用「700万円以上〜800万円未満」"
      when 8190
        @selected_cost = "治療費用「800万円以上〜900万円未満」"
      when 91100
        @selected_cost = "治療費用「900万円以上〜1,000万円未満」"
      when 101000
        @selected_cost = "治療費用「1,000万円以上(または不明)」"
      end
      if cost_value.length == 2
        i = cost_value.split(//,2)
        a = i[0]
        b = i[1]
        @reports = Report.where(cost: a..b, status: 0).order(created_at: :desc)
      elsif cost_value.length == 3
        i = cost_value.split(//,2)
        a = i[0]
        b = i[1]
        @reports = Report.where(cost: a..b, status: 0).order(created_at: :desc)
      elsif cost_value.length == 4
        i = cost_value.scan(/.{2}/)
        a = i[0]
        b = i[1]
        @reports = Report.where(cost: a..b, status: 0).order(created_at: :desc)
      elsif cost_value.length == 5 
        i = cost_value.split(/\A(.{1,2})/,2)
        a = i[0]
        b = i[1]
        @reports = Report.where(cost: a..b, status: 0).order(created_at: :desc)
      else cost_value.length > 5
        i = cost_value.split(/\A(.{1,3})/,2)
        a = i[1]
        b = "104"
        @reports = Report.where(cost: a..b, status: 0).order(created_at: :desc)
      end
    end
  end
end