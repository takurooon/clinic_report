class SearchesController < ApplicationController

  def search
  end

  def all_amh
    amhs = Report::HASH_AMH_SEARCH
    reports = Report.group(:amh).where.not(amh: nil).distinct.size
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
    reports = Report.where(amh: amh_value, status: 0).order(created_at: :desc)
    @reports_count = reports.size
    @reports = reports.page(params[:page]).per(20)
    @like_count = Like.group(:report_id).size
  end

  def all_status
    current_statuses = Report::HASH_CURRENT_STATE_SEARCH
    current_state_reports = Report.group(:current_state).where.not(current_state: nil, status: 1).distinct.size
    c = current_statuses.keys - current_state_reports.keys
    c.each do |s|
      current_statuses.delete(s)
    end
    @current_status = current_statuses
  end

  def status
    status = Report::HASH_CURRENT_STATE_SEARCH
    status_value = params[:value].to_i
    @selected_word = status[status_value]
    reports = Report.where(current_state: status_value, status: 0).order(created_at: :desc)
    @reports_count = reports.size
    @reports = reports.page(params[:page]).per(20)
    @like_count = Like.group(:report_id).size
  end

  def what_numbers
    fertility_treatment_number = Report::HASH_FERTILITY_TREATMENT_NUMBER_SEARCH
    fertility_treatment_number_reports = Report.group(:fertility_treatment_number).where.not(fertility_treatment_number: nil, status: 1).distinct.size
    f = fertility_treatment_number.keys - fertility_treatment_number_reports.keys
    f.each do |t|
      fertility_treatment_number.delete(t)
    end
    @fertility_treatment_number = fertility_treatment_number
  end

  def what_number
    fertility_treatment_number = Report::HASH_FERTILITY_TREATMENT_NUMBER_SEARCH
    fertility_treatment_number_value = params[:value].to_i
    @selected_number = fertility_treatment_number[fertility_treatment_number_value]
    reports = Report.where(fertility_treatment_number: fertility_treatment_number_value, status: 0).order(created_at: :desc)
    @reports_count = reports.size
    @reports = reports.page(params[:page]).per(20)
    @like_count = Like.group(:report_id).size
  end

  def clinics
    # @clinics = Clinic.all.includes(:reports)
    # @prefecture = Prefecture.where(id: 1..47)
    # @all_clinics = Clinic.all.order(prefecture_id: :asc, city_id: :asc)
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
    @clinic_all_reports = Report.where(clinic_id: @clinics.id, status: 0).size
    @like_count = Like.group(:report_id).size
  end

  def clinics_area
    @clinics = Clinic.all
  end

  # def clinic_prefecture_area
  #   @prefecture = Prefecture.find_by(id: params[:value])
  #   clinics = Clinic.where(prefecture_id: @prefecture.id)
  #   @prefecture_clinics = Clinic.where(prefecture_id: @prefecture).name_yomigana
  #   @reports = Report.where(clinic_id: clinics.ids, status: 0).order(created_at: :desc)
  #   @clinic_all_reports = Report.where(clinic_id: clinics.ids, status: 0).count
  #   @rereased_reports = Clinic.joins(:reports).where(city_id: @prefecture.id, reports: {status: 0})
  # end

  # def clinic_city_area
  #   @city = City.find_by(id: params[:value])
  #   clinics = Clinic.where(city_id: @city.id)
  #   @city_clinics = Clinic.where(city_id: @city.id).name_yomigana
  #   @reports = Report.where(clinic_id: clinics.ids, status: 0).order(created_at: :desc)
  #   @clinic_all_reports = Report.where(clinic_id: clinics.ids, status: 0).count
  #   @rereased_reports = Clinic.joins(:reports).where(city_id: @city.id, reports: {status: 0})
  # end

  def all_age
    age = Report::HASH_TREATMENT_END_AGE_SEARCH
    reports = Report.group(:treatment_end_age).where.not(treatment_end_age: nil, status: 1).distinct.size
    all_age = age.keys - reports.keys
    all_age.each do |aa|
      age.delete(aa)
    end
    @age = age

    @range_age = {}
    age.keys.each do |range|
      case range
      when 19
        range_v_1 = "~19000"
        range_n_1 = "20歳未満"
        @range_age[range_v_1] = range_n_1
      when 20..24
        range_v_2 = "20~24"
        range_n_2 = "20〜24歳"
        @range_age[range_v_2] = range_n_2
      when 25..29
        range_v_3 = "25~29"
        range_n_3 = "25〜29歳"
        @range_age[range_v_3] = range_n_3
      when 30..34
        range_v_4 = "30~34"
        range_n_4 = "30〜34歳"
        @range_age[range_v_4] = range_n_4
      when 35..39
        range_v_5 = "35~39"
        range_n_5 = "35〜39歳"
        @range_age[range_v_5] = range_n_5
      when 40..44
        range_v_6 = "40~44"
        range_n_6 = "40〜44歳"
        @range_age[range_v_6] = range_n_6
      when 45..44
        range_v_7 = "45~49"
        range_n_7 = "45〜45歳"
        @range_age[range_v_7] = range_n_7
      when 50
        range_v_8 = "50000~"
        range_n_8 = "50歳以上"
        @range_age[range_v_8] = range_n_8
      end
    end
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
    when 4549
      @selected_age = "45〜45歳"
    when 50000
      @selected_age = "50歳以上"
    when 19000
      @selected_age = "20歳未満"
    when 19
      @selected_age = "19歳未満"
    when 50
      @selected_age = "50歳以上"
    else
      @selected_age = age_value + "歳"
    end
    if age_value.length == 4
      i = age_value.scan(/.{2}/)
      a = i[0]
      b = i[1]
      reports = Report.where(treatment_end_age: a..b, status: 0).order(created_at: :desc)
      @reports_count = reports.size
      @reports = reports.page(params[:page]).per(20)
    elsif age_value.length == 5
      i = age_value.scan(/.{2}/)
      reports = Report.where(treatment_end_age: i[0], status: 0).order(created_at: :desc)
      @reports_count = reports.size
      @reports = reports.page(params[:page]).per(20)
    else
      reports = Report.where(treatment_end_age: age_value, status: 0).order(created_at: :desc)
      @reports_count = reports.size
      @reports = reports.page(params[:page]).per(20)
    end
    @like_count = Like.group(:report_id).size
  end

  def count
    sairan = Report::HASH_TOTAL_NUMBER_OF_SAIRAN_SEARCH
    reports = Report.group(:total_number_of_sairan).where.not(total_number_of_sairan: nil, status: 1).distinct.size
    all_sairan = sairan.keys - reports.keys
    all_sairan.each do |aa|
      sairan.delete(aa)
    end
    @sairan = sairan

    ishoku = Report::HASH_TOTAL_NUMBER_OF_TRANSPLANTS_SEARCH
    reports = Report.group(:total_number_of_transplants).where.not(total_number_of_transplants: nil, status: 1).distinct.size
    all_ishoku = ishoku.keys - reports.keys
    all_ishoku.each do |aa|
      ishoku.delete(aa)
    end
    @ishoku = ishoku
  end

  def sairan_ishoku_count
    if params[:type] == "sairan"
      sairan = Report::HASH_TOTAL_NUMBER_OF_SAIRAN_SEARCH
      sairan_value = params[:value].to_i
      @selected_sairan_ishoku = sairan[sairan_value]
      @selected_sairan_ishoku_name = "採卵"
      reports = Report.where(total_number_of_sairan: sairan_value, status: 0).order(created_at: :desc)
      @reports_count = reports.size
      @reports = reports.page(params[:page]).per(20)
    elsif params[:type] == "ishoku"
      ishoku = Report::HASH_TOTAL_NUMBER_OF_TRANSPLANTS_SEARCH
      ishoku_value = params[:value].to_i
      @selected_sairan_ishoku = ishoku[ishoku_value]
      @selected_sairan_ishoku_name = "移植"
      reports = Report.where(total_number_of_transplants: ishoku_value, status: 0).order(created_at: :desc)
      @reports_count = reports.size
      @reports = reports.page(params[:page]).per(20)
    end
    @like_count = Like.group(:report_id).size
  end

  def cycletype
    sairan_type = Report::HASH_TYPE_OF_OVARIAN_STIMULATION_SEARCH
    reports = Report.group(:type_of_ovarian_stimulation).where.not(type_of_ovarian_stimulation: nil, status: 1).distinct.size
    all_sairan_type = sairan_type.keys - reports.keys
    all_sairan_type.each do |aa|
      sairan_type.delete(aa)
    end
    @sairan_type = sairan_type

    ishoku_type = Report::HASH_ISHOKU_TYPE_SEARCH
    reports = Report.group(:ishoku_type).where.not(ishoku_type: nil, status: 1).distinct.size
    all_ishoku_type = ishoku_type.keys - reports.keys
    all_ishoku_type.each do |aa|
      ishoku_type.delete(aa)
    end
    @ishoku_type = ishoku_type
  end

  def cycletype_sairan_ishoku
    if params[:type] == "sairan"
      sairan_cycletype = Report::HASH_TYPE_OF_OVARIAN_STIMULATION_SEARCH
      sairan_cycletype_value = params[:value].to_i
      @selected_cycletype_sairan_ishoku = sairan_cycletype[sairan_cycletype_value]
      @selected_cycletype_sairan_ishoku_name = "採卵: "
      reports = Report.where(type_of_ovarian_stimulation: sairan_cycletype_value, status: 0).order(created_at: :desc)
      @reports_count = reports.size
      @reports = reports.page(params[:page]).per(20)
    elsif params[:type] == "ishoku"
      ishoku_cycletype = Report::HASH_ISHOKU_TYPE_SEARCH
      ishoku_cycletype_value = params[:value].to_i
      @selected_cycletype_sairan_ishoku = ishoku_cycletype[ishoku_cycletype_value]
      @selected_cycletype_sairan_ishoku_name = "移植: "
      reports = Report.where(ishoku_type: ishoku_cycletype_value, status: 0).order(created_at: :desc)
      @reports_count = reports.size
      @reports = reports.page(params[:page]).per(20)
    end
    @like_count = Like.group(:report_id).size
  end

  def grade
    haibanho = Report::HASH_BLASTOCYST_GRADE1_GRADE2_SEARCH
    reports = Report.group(:blastocyst_grade1, :blastocyst_grade2).where.not(blastocyst_grade1: nil, blastocyst_grade2: nil, status: 1).distinct.size
    reports_haibanho = reports.keys.map do |r|
      r.join.to_i
    end
    haibanho_grade = haibanho.keys - reports_haibanho
    haibanho_grade.each do |h|
      haibanho.delete(h)
    end
    @haibanho = haibanho

    shokihai = Report::HASH_EARLY_EMBRYO_GRADE_SEARCH
    reports = Report.group(:early_embryo_grade).where.not(early_embryo_grade: nil, status: 1).distinct.size
    shokihai_grade = shokihai.keys - reports.keys
    shokihai_grade.each do |aa|
      shokihai.delete(aa)
    end
    @shokihai = shokihai
  end

  def embryo_grade
    if params[:type] == "haibanho"
      haibanho = Report::HASH_BLASTOCYST_GRADE1_GRADE2_SEARCH
      haibanho_value = params[:value]
      if haibanho_value.size == 2
        blastocyst_grade1_value = haibanho_value[0]
        blastocyst_grade2_value = haibanho_value[1]
      elsif haibanho_value.size == 3 && haibanho_value.to_i >= 199 && haibanho_value.to_i <= 699
        haibanho_num = haibanho_value.split(/\A(.{1,1})/, 2)[1..-1]
        blastocyst_grade1_value = haibanho_value[0]
        blastocyst_grade2_value = haibanho_value[1]
      elsif haibanho_value.size == 3 && haibanho_value.to_i >= 991 && haibanho_value.to_i <= 999
        haibanho_num = haibanho_value.split(/\A(.{1,2})/, 2)[1..-1]
        blastocyst_grade1_value = haibanho_value[0..1]
        blastocyst_grade2_value = haibanho_value[2]
      elsif haibanho_value.size == 6
        haibanho_num = haibanho_value.split(/\A(.{1,3})/, 2)[1..-1]
        blastocyst_grade1_value = haibanho_value[0..2]
        blastocyst_grade2_value = haibanho_value[3..5]
      end
      @selected_grade = haibanho[haibanho_value.to_i]
      @selected_grade_name = "胚盤胞"
      reports = Report.where(blastocyst_grade1: blastocyst_grade1_value.to_i, blastocyst_grade2: blastocyst_grade2_value.to_i, status: 0).order(created_at: :desc)
      @reports_count = reports.size
      @reports = reports.page(params[:page]).per(20)
    elsif params[:type] == "shokihai"
      shokihai = Report::HASH_EARLY_EMBRYO_GRADE_SEARCH
      shokihai_value = params[:value].to_i
      @selected_grade = shokihai[shokihai_value]
      @selected_grade_name = "初期胚"
      reports = Report.where(early_embryo_grade: shokihai_value, status: 0).order(created_at: :desc)
      @reports_count = reports.size
      @reports = reports.page(params[:page]).per(20)
    end
    @like_count = Like.group(:report_id).size
  end

  def tags
    report_fuiku_inspections = ReportFuikuInspection.joins(:report, :fuiku_inspection).where(reports: {status: 0}).group(:fuiku_inspection_id).size
    fuiku_inspection = report_fuiku_inspections.keys
    @fuiku_inspections = FuikuInspection.where(id: fuiku_inspection).name_yomigana
    report_f_funin_factors = ReportFFuninFactor.joins(:report, :f_funin_factor).where(reports: {status: 0}).group(:f_funin_factor_id).size
    f_funin_factor = report_f_funin_factors.keys
    @f_funin_factors = FFuninFactor.where(id: f_funin_factor)
    if SpecialInspection.joins({report: :clinic}).where(name: 18).where.not(place: [1, 4], clinics: {pgt: 0}).pluck(:name)[0].present?
      pgta = nil
    end
    @special_examinations = SpecialInspection.joins(:report).where.not(name: [nil, pgta], reports: {status: 1}).select(:name).distinct
  end

  def tag
    if params[:type] === "factor"
      @tag = FFuninFactor.find_by(id: params[:value])
      reports = @tag.reports.where(reports: {status: 0}).order(created_at: :desc)
      @reports = reports.page(params[:page]).per(20)
    elsif params[:type] === "option"
      @tag = SpecialInspection.find_by(name: params[:value])
      pgta_report = SpecialInspection.joins({report: :clinic}).where(name: 18, place: [1, 4], clinics: {pgt: 0}).distinct.pluck(:report_id)
      reports = Report.joins(:special_inspections).where(special_inspections: { name: @tag.name }, reports: {status: 0}).where.not(id: pgta_report).order(created_at: :desc)
      @reports_count = reports.size
      @reports = reports.page(params[:page]).per(20)
    elsif params[:type] === "fuiku"
      @tag = FuikuInspection.find_by(id: params[:value])
      reports = @tag.reports.where(reports: {status: 0}).order(created_at: :desc)
      @reports_count = reports.size
      @reports = reports.page(params[:page]).per(20)
    end
    @like_count = Like.group(:report_id).size
  end

  def works
    works = Report::HASH_WORK_STYLE_SEARCH
    reports = Report.group(:work_style).where.not(work_style: nil, status: 1).distinct.count
    w = works.keys - reports.keys
    w.each do |wo|
      works.delete(wo)
    end
    @works = works
  end

  def work
    work = Report::HASH_WORK_STYLE_SEARCH
    work_value = params[:value].to_i
    @selected_work = "「" + work[work_value] + "」"
    reports = Report.where(work_style: work_value, status: 0).order(created_at: :desc)
    @reports_count = reports.size
    @reports = reports.page(params[:page]).per(20)
    @like_count = Like.group(:report_id).size
  end

  def works_switch
    works_switch = Report::HASH_SWITCHING_WORK_STYLES_SEARCH
    reports = Report.group(:switching_work_styles).where.not(switching_work_styles: nil, status: 1).distinct.count
    w = works_switch.keys - reports.keys
    w.each do |wo|
      works_switch.delete(wo)
    end
    @works_switch = works_switch
  end

  def work_switch
    work_switch = Report::HASH_SWITCHING_WORK_STYLES_SEARCH
    work_switch_value = params[:value].to_i
    @selected_work_switch = "「" + work_switch[work_switch_value] + "」"
    reports = Report.where(switching_work_styles: work_switch_value, status: 0).order(created_at: :desc)
    @reports_count = reports.size
    @reports = reports.page(params[:page]).per(20)
    @like_count = Like.group(:report_id).size
  end

  def costs
    total_costs = Report::HASH_COST_SEARCH
    reports = Report.group(:cost).where.not(cost: nil, status: 1).distinct.size
    v_cost = total_costs.keys - reports.keys
    v_cost.each do |vc|
      total_costs.delete(vc)
    end
    @total_costs = total_costs

    @range_cost = {}
    total_costs.keys.each do |range|
      case range
      when 1..2
        range_v_1 = "1~2"
        range_n_1 = "50万円未満"
        @range_cost[range_v_1] = range_n_1
      when 3
        range_v_2 = "3"
        range_n_2 = "50万円以上〜100万円未満"
        @range_cost[range_v_2] = range_n_2
      when 4..5
        range_v_3 = "4~50"
        range_n_3 = "100万円以上〜200万円未満"
        @range_cost[range_v_3] = range_n_3
      when 6..7
        range_v_4 = "6~70"
        range_n_4 = "200万円以上〜300万円未満"
        @range_cost[range_v_4] = range_n_4
      when 8..9
        range_v_5 = "8~90"
        range_n_5 = "300万円以上〜400万円未満"
        @range_cost[range_v_5] = range_n_5
      when 10..11
        range_v_6 = "10~11"
        range_n_6 = "400万円以上〜500万円未満"
        @range_cost[range_v_6] = range_n_6
      when 12
        range_v_7 = "12000"
        range_n_7 = "500万円以上〜600万円未満"
        @range_cost[range_v_7] = range_n_7
      when 13
        range_v_8 = "13000"
        range_n_8 = "600万円以上〜700万円未満"
        @range_cost[range_v_8] = range_n_8
      when 14
        range_v_9 = "14000"
        range_n_9 = "700万円以上〜800万円未満"
        @range_cost[range_v_9] = range_n_9
      when 15
        range_v_10 = "15000"
        range_n_10 = "800万円以上〜900万円未満"
        @range_cost[range_v_10] = range_n_10
      when 16
        range_v_11 = "16000"
        range_n_11 = "900万円以上〜1,000万円未満"
        @range_cost[range_v_11] = range_n_11
      when 17
        range_v_12 = "17000"
        range_n_12 = "1,000万円以上"
        @range_cost[range_v_12] = range_n_12
      end
    end

    sairan_cost = Report::HASH_SAIRAN_COST_SEARCH
    reports = Report.group(:sairan_cost).where.not(sairan_cost: nil, status: 1).distinct.count
    sairan = sairan_cost.keys - reports.keys
    sairan.each do |sc|
      sairan_cost.delete(sc)
    end
    @sairan_cost = sairan_cost

    ishoku_cost = Report::HASH_ISHOKU_COST_SEARCH
    reports = Report.group(:ishoku_cost).where.not(ishoku_cost: nil, status: 1).distinct.count
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
      reports = Report.where(cost: cost_value, status: 0).order(created_at: :desc)
      @reports_count = reports.size
      @reports = reports.page(params[:page]).per(20)
    elsif params[:value].include?("_sairan")
      sairan_cost = Report::HASH_SAIRAN_COST_SEARCH
      sairan_cost_value = params[:value].to_i
      @selected_cost = "採卵1回あたりの費用「" + sairan_cost[sairan_cost_value] + "」"
      reports = Report.where(sairan_cost: sairan_cost_value, status: 0).order(created_at: :desc)
      @reports_count = reports.size
      @reports = reports.page(params[:page]).per(20)
    elsif params[:value].include?("_ishoku")
      ishoku_cost = Report::HASH_ISHOKU_COST_SEARCH
      ishoku_cost_value = params[:value].to_i
      @selected_cost = "移植1回あたりの費用「" + ishoku_cost[ishoku_cost_value] + "」"
      reports = Report.where(ishoku_cost: ishoku_cost_value, status: 0).order(created_at: :desc)
      @reports_count = reports.size
      @reports = reports.page(params[:page]).per(20)
    else
      value = params[:value]
      cost_value = value.delete("^0-9")
      case cost_value.to_i
      when 12
        @selected_cost = "治療費用「50万円未満」"
      when 3
        @selected_cost = "治療費用「50万円以上〜100万円未満」"
      when 450
        @selected_cost = "治療費用「100万円以上〜200万円未満」"
      when 670
        @selected_cost = "治療費用「200万円以上〜300万円未満」"
      when 890
        @selected_cost = "治療費用「300万円以上〜400万円未満」"
      when 1011
        @selected_cost = "治療費用「400万円以上〜500万円未満」"
      when 12000
        @selected_cost = "治療費用「500万円以上〜600万円未満」"
      when 13000
        @selected_cost = "治療費用「600万円以上〜700万円未満」"
      when 14000
        @selected_cost = "治療費用「700万円以上〜800万円未満」"
      when 15000
        @selected_cost = "治療費用「800万円以上〜900万円未満」"
      when 16000
        @selected_cost = "治療費用「900万円以上〜1,000万円未満」"
      when 17000
        @selected_cost = "治療費用「1,000万円以上(または不明)」"
      end
      if cost_value.length == 1
        a = cost_value
        reports = Report.where(cost: a, status: 0).order(created_at: :desc)
      elsif cost_value.length == 2
        i = cost_value.split(//,2)
        a = i[0]
        b = i[1]
        reports = Report.where(cost: a..b, status: 0).order(created_at: :desc)
      elsif cost_value.length == 3
        i = cost_value.split(//,3)
        a = i[0]
        b = i[1]
        reports = Report.where(cost: a..b, status: 0).order(created_at: :desc)
      elsif cost_value.length == 4
        i = cost_value.scan(/.{2}/)
        a = i[0]
        b = i[1]
        reports = Report.where(cost: a..b, status: 0).order(created_at: :desc)
      else cost_value.length == 5
        i = cost_value.split(/\A(.{1,2})/,2)
        a = i[1]
        reports = Report.where(cost: a, status: 0).order(created_at: :desc)
      end
      @reports_count = reports.size
      @reports = reports.page(params[:page]).per(20)
    end
    @like_count = Like.group(:report_id).size
  end

  # 以下は4つのメソッドはclinics_controllerから移植(ここから)
  def cities_select_clinics
    # クリニックが存在するcityだけを抽出
    @cities = City.where(prefecture_id: params[:prefecture_id]).order(:id).joins(:clinics).distinct
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

    # クリニックが存在する市区町村だけ抽出(clはid順→できればyomigamna順にしたいが...)
    clinics = Clinic.where(prefecture_id: params[:prefecture_id]).group(:city_id).pluck(:city_id).sort
    @cities = City.where(id: clinics)
    render partial: 'address/clinics_by_city'
  end
  # ここまで
end
