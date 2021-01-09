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
    @clinic_all_reports = @reports.count
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
    if params[:value].include?("child")
      fertility_treatment_number = Report::HASH_FERTILITY_TREATMENT_NUMBER_SEARCH
      fertility_treatment_number_value = params[:value].to_i
      @selected_word = fertility_treatment_number[fertility_treatment_number_value]
      @reports = Report.where(fertility_treatment_number: fertility_treatment_number_value, status: 0).order(created_at: :desc)
      @clinic_all_reports = @reports.count
    else
      status = Report::HASH_CURRENT_STATE_SEARCH
      status_value = params[:value].to_i
      @selected_word = status[status_value]
      @reports = Report.where(current_state: status_value, status: 0).order(created_at: :desc)
      @clinic_all_reports = @reports.count
    end
  end

  def clinics
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

  def clinic
    @clinics = Clinic.find_by(id: params[:value])
    @reports = Report.where(clinic_id: @clinics.id, status: 0)
    @clinic_reports = Report.where(activated: true).search(params[:search]).order(created_at: :desc)
    @transfer_reports = Report.joins(:itinerary_of_choosing_a_clinics).where(status: 0, itinerary_of_choosing_a_clinics: {clinic_id: @clinics.id}).distinct
    @clinic_all_reports = Report.where(clinic_id: @clinics.id, status: 0).count
  end

  def clinics_area
    @clinics = Clinic.all
  end

  def clinic_prefecture_area
    @prefecture = Prefecture.find_by(name: params[:value])
    clinics = Clinic.where(prefecture_id: @prefecture)
    @prefecture_clinics = Clinic.where(prefecture_id: @prefecture).name_yomigana
    @reports = Report.where(clinic_id: clinics.ids, status: 0).order(created_at: :desc)
    @clinic_all_reports = Report.where(clinic_id: clinics.ids, status: 0).count
    @rereased_reports = Clinic.joins(:reports).where(city_id: @prefecture.id, reports: {status: 0})
  end
  
  def clinic_city_area
    @city = City.find_by(name: params[:value])
    clinics = Clinic.where(city_id: @city.id)
    @city_clinics = Clinic.where(city_id: @city.id).name_yomigana
    @reports = Report.where(clinic_id: clinics.ids, status: 0).order(created_at: :desc)
    @clinic_all_reports = Report.where(clinic_id: clinics.ids, status: 0).count
    @rereased_reports = Clinic.joins(:reports).where(city_id: @city.id, reports: {status: 0})
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
      @clinic_all_reports = @reports.count
    else
      @reports = Report.where(treatment_end_age: age_value, status: 0).order(created_at: :desc)
      @clinic_all_reports = @reports.count
    end
  end

  def tags
    report_fuiku_inspections = ReportFuikuInspection.joins(:report, :fuiku_inspection).where(reports: {status: 0}).group(:fuiku_inspection_id).count
    fuiku_inspection = report_fuiku_inspections.keys
    @fuiku_inspections = FuikuInspection.where(id: fuiku_inspection).name_yomigana
    report_f_funin_factors = ReportFFuninFactor.joins(:report, :f_funin_factor).where(reports: {status: 0}).group(:f_funin_factor_id).count
    f_funin_factor = report_f_funin_factors.keys
    @f_funin_factors = FFuninFactor.where(id: f_funin_factor)
    @special_examinations = SpecialInspection.joins(:report).where(reports: {status: 0}).group(:id).distinct
  end

  def tag
    if params[:gender] === "女性"
      if params[:tags] === "特殊検査"
        @tag = SpecialInspection.find_by(name: params[:value])
        @reports = Report.joins(:special_inspections).where(special_inspections: { name: @tag.name }, reports: {status: 0})
        @clinic_all_reports = @reports.count
      elsif params[:tags] === "不育症"
        @tag = FuikuInspection.find_by(name: params[:value])
        @reports = @tag.reports.where(reports: {status: 0}).order(created_at: :desc)
        @clinic_all_reports = @reports.count
      elsif
        params[:tags] === "不妊原因"
        @tag = FFuninFactor.find_by(name: params[:value])
        @reports = @tag.reports.where(reports: {status: 0}).order(created_at: :desc)
        @clinic_all_reports = @reports.count
      end
    end
  end

  def all_area
  end

  def works
    works = Report::HASH_WORK_STYLE_SEARCH
    reports = Report.group(:work_style).where.not(work_style: nil).distinct.count
    w = works.keys - reports.keys
    w.each do |wo|
      works.delete(wo)
    end
    @works = works
  end

  def work
    work_style = Report::HASH_WORK_STYLE_SEARCH
    work_value = params[:value].to_i
    @selected_work = "「" + work_style[work_value] + "」"
    @reports = Report.where(work_style: work_value, status: 0).order(created_at: :desc)
    @clinic_all_reports = @reports.count
  end

  def costs
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
    if params[:value].include?("_all")
      cost = Report::HASH_COST_SEARCH
      cost_value = params[:value].to_i
      @selected_cost = "治療費用「" + cost[cost_value] + "」"
      @reports = Report.where(cost: cost_value, status: 0).order(created_at: :desc)
      @clinic_all_reports = @reports.count
    elsif params[:value].include?("_sairan")
      sairan_cost = Report::HASH_SAIRAN_COST_SEARCH
      sairan_cost_value = params[:value].to_i
      @selected_cost = "採卵1回あたりの費用「" + sairan_cost[sairan_cost_value] + "」"
      @reports = Report.where(sairan_cost: sairan_cost_value, status: 0).order(created_at: :desc)
      @clinic_all_reports = @reports.count
    elsif params[:value].include?("_ishoku")
      ishoku_cost = Report::HASH_ISHOKU_COST_SEARCH
      ishoku_cost_value = params[:value].to_i
      @selected_cost = "移植1回あたりの費用「" + ishoku_cost[ishoku_cost_value] + "」"
      @reports = Report.where(ishoku_cost: ishoku_cost_value, status: 0).order(created_at: :desc)
      @clinic_all_reports = @reports.count
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
        @clinic_all_reports = @reports.count
      elsif cost_value.length == 3
        i = cost_value.split(//,2)
        a = i[0]
        b = i[1]
        @reports = Report.where(cost: a..b, status: 0).order(created_at: :desc)
        @clinic_all_reports = @reports.count
      elsif cost_value.length == 4
        i = cost_value.scan(/.{2}/)
        a = i[0]
        b = i[1]
        @reports = Report.where(cost: a..b, status: 0).order(created_at: :desc)
        @clinic_all_reports = @reports.count
      elsif cost_value.length == 5 
        i = cost_value.split(/\A(.{1,2})/,2)
        a = i[0]
        b = i[1]
        @reports = Report.where(cost: a..b, status: 0).order(created_at: :desc)
        @clinic_all_reports = @reports.count
      else cost_value.length > 5
        i = cost_value.split(/\A(.{1,3})/,2)
        a = i[1]
        b = "104"
        @reports = Report.where(cost: a..b, status: 0).order(created_at: :desc)
        @clinic_all_reports = @reports.count
      end
    end
  end

  # 以下は4つのメソッドはclinics_controllerから移植(ここから)
  def cities_select_clinics
    # クリニックが存在するcityだけを抽出
    @cities = City.where(prefecture_id: params[:prefecture_id]).order(:id).joins(:clinics).distinct
    render partial: 'address/cities'
  end

  def cities_select_area
    # 住まい検索
    @cities = City.where(prefecture_id: params[:prefecture_id]).order(:id)
    # ある程度レポコが溜まってきたら上を止め、下のコードを有効にする(レポコ投稿者のいない市区町村は表示しない仕様)
    # @cities = City.where(prefecture_id: params[:prefecture_id]).order(:id).joins(:reports).distinct
    render partial: 'address/cities'
  end

  def clinics_select
    # 新規投稿はvalueがname、編集はvalueがidなので以下で判定
    if (/^[+-]?[0-9]+$/ =~ params[:city_name].to_s)
      city = City.find_by(id: params[:city_name])
    else 
      city = City.find_by(name: params[:city_name])
    end
    @clinics = Clinic.where(city_id: city.id).clinic_name_yomigana
    render partial: 'address/clinics'
  end

  def clinic_select
    @clinics = Clinic.where(prefecture_id: params[:prefecture_id]).clinic_name_yomigana
    render partial: 'address/clinics'
  end
  # ここまで

end