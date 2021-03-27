class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]

  def index
    # @reports = params[:tag_id].present? ? Tag.find(params[:tag_id]).reports : Report.all
    # @toptags = Tag.find(ReportTag.group(:tag_id).order('count(tag_id) desc').limit(5).pluck(:tag_id))
    @reports = Report.released.order("created_at DESC").page(params[:page]).per(30)
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
        yomigana: clinic.yomigana
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
        yomigana: clinic.yomigana
      }
    end
    @all_clinics = Clinic.count.to_s(:delimited)
    @ivf_clinics = Clinic.where(ivf: 1).count.to_s(:delimited)

    @user = current_user
    if @user.present?
      @draft_reports = @user.reports.nonreleased
    end
  end

  def draft
    @user = current_user
    @reports = @user.reports.nonreleased.order("created_at DESC").page(params[:page]).per(10)
  end

  def show
    @comment = Comment.new(report_id: @report.id)

    if @report.nonreleased? && @report.user != current_user
      redirect_to root_path
    end

    @clinics = @report.itinerary_of_choosing_a_clinics.order(order_of_transfer: "desc")
    @clinics_exist = @clinics.map { |i| i[:clinic_id] }

    @unsuccessful_sairan_cycles = @report.unsuccessful_sairan_cycles.order(un_sairan_number: "asc")
    @unsuccessful_ishoku_cycles = @report.unsuccessful_ishoku_cycles.order(un_ishoku_number: "asc")

    @special_inspection_era = @report.special_inspections.where(name: 1)
    @special_inspection_emma = @report.special_inspections.where(name: 2)
    @special_inspection_alice = @report.special_inspections.where(name: 3)
    @special_inspection_trio = @report.special_inspections.where(name: 4)
    @special_inspection_erpeak = @report.special_inspections.where(name: 5)
    @special_inspection_hysteroscopy = @report.special_inspections.where(name: 6)
    @special_inspection_intrauterine_flora = @report.special_inspections.where(name: 7)
    @special_inspection_endometrial_biopsy = @report.special_inspections.where(name: 8)
    @special_inspection_hidukeshin = @report.special_inspections.where(name: 9)
    @special_inspection_bce = @report.special_inspections.where(name: 10)
    @special_inspection_chromosome = @report.special_inspections.where(name: 11)
    @special_inspection_ca125 = @report.special_inspections.where(name: 12)
    @special_inspection_mri = @report.special_inspections.where(name: 13)
    @special_inspection_vitamin_d = @report.special_inspections.where(name: 14)
    @special_inspection_copper_zinc = @report.special_inspections.where(name: 15)
    @special_inspection_kruger = @report.special_inspections.where(name: 16)
    @special_inspection_dfi = @report.special_inspections.where(name: 17)
    @special_inspection_pgta = @report.special_inspections.where(name: 18)
    @special_inspection_other_inspection = @report.special_inspections.where(name: 99)

    gon.clinic_name = @report.clinic.name
    gon.clinic_evaluation = []
    gon.clinic_evaluation << @report.doctor_quality << @report.staff_quality << @report.impression_of_technology << @report.impression_of_price << @report.average_waiting_time2 << @report.comfort_of_space
    @clinic_evaluation = gon.clinic_evaluation.compact

    if @report.doctor_quality.blank?
      @report.doctor_quality = 0
    end
    if @report.staff_quality.blank?
      @report.staff_quality = 0
    end
    if @report.impression_of_technology.blank?
      @report.impression_of_technology = 0
    end
    if @report.impression_of_price.blank?
      @report.impression_of_price = 0
    end
    if @report.average_waiting_time2.blank?
      @report.average_waiting_time2 = 0
    end
    if @report.comfort_of_space.blank?
      @report.comfort_of_space = 0
    end
    @average_score = ((@report.doctor_quality + @report.staff_quality + @report.impression_of_technology + @report.impression_of_price + @report.average_waiting_time2 + @report.comfort_of_space)/6.to_f).round(1)
    
    # ホルモン値
    day_of_sairans = @report.day_of_sairans
    @day_of_sairans = day_of_sairans.pluck(:day, :e2, :fsh, :lh, :p4).flatten!
    sairan_days = @report.day_of_sairans.pluck(:day)
    if sairan_days
      sairan_day = sairan_days.map do |sairan_day|
        "D" + sairan_day.to_s + "(採卵日)"
      end
    else
      sairan_day = "採卵日:未回答"
    end
    sairan_hormones = @report.sairan_hormones.order(day: "ASC")
    @sairan_hormones = sairan_hormones.pluck(:day, :e2, :fsh, :lh, :p4).flatten!

    sairan_hormones_days = sairan_hormones.map { |d| d[:day] }
    sairan_hormones_day = sairan_hormones_days.map do |d|
      "D" + d.to_s
    end
    sairan_hormones_day_sairan_day = sairan_hormones_day << sairan_day
    gon.sairan_hormones_day = sairan_hormones_day_sairan_day.flatten

    day_of_sairan_e2 = day_of_sairans.map { |de2| de2[:e2] }
    sairan_hormones_e2 = sairan_hormones.map { |e| e[:e2] }
    sairan_hormones_e2_de2 = sairan_hormones_e2 << day_of_sairan_e2
    gon.sairan_hormones_e2 = sairan_hormones_e2_de2.flatten

    day_of_sairan_fsh = day_of_sairans.map { |dfsh| dfsh[:fsh] }
    sairan_hormones_fsh = sairan_hormones.map { |f| f[:fsh] }
    sairan_hormones_fsh_dfsh = sairan_hormones_fsh << day_of_sairan_fsh
    gon.sairan_hormones_fsh = sairan_hormones_fsh_dfsh.flatten

    day_of_sairan_lh = day_of_sairans.map { |dlh| dlh[:lh] }
    sairan_hormones_lh = sairan_hormones.map { |l| l[:lh] }
    sairan_hormones_lh_dlh = sairan_hormones_lh << day_of_sairan_lh
    gon.sairan_hormones_lh = sairan_hormones_lh_dlh.flatten

    day_of_sairan_p4 = day_of_sairans.map { |dp4| dp4[:p4] }
    sairan_hormones_p4 = sairan_hormones.map { |p| p[:p4] }
    sairan_hormones_p4_dp4 = sairan_hormones_p4 << day_of_sairan_p4
    gon.sairan_hormones_p4 = sairan_hormones_p4_dp4.flatten

    before_ishoku_hormones = @report.before_ishoku_hormones.order(day: "ASC")
    @before_ishoku_hormones = before_ishoku_hormones.pluck(:day, :e2, :fsh, :lh, :p4).flatten!
    before_ishoku_hormones_days = before_ishoku_hormones.map { |bd| bd[:day] }
    before_ishoku_hormones_day = before_ishoku_hormones_days.map do |bd|
      "D" + bd.to_s
    end
    before_ishoku_hormones_e2 = before_ishoku_hormones.map { |be2| be2[:e2] }
    before_ishoku_hormones_fsh = before_ishoku_hormones.map { |bfsh| bfsh[:fsh] }
    before_ishoku_hormones_lh = before_ishoku_hormones.map { |blh| blh[:lh] }
    before_ishoku_hormones_p4 = before_ishoku_hormones.map { |bp4| bp4[:p4] }

    day_of_haibanhoishokus = @report.day_of_haibanhoishokus
    @day_of_haibanhoishokus = day_of_haibanhoishokus.pluck(:day, :e2, :fsh, :lh, :p4).flatten!
    @haibanhoishokus_endometrial_thickness = day_of_haibanhoishokus.pluck(:endometrial_thickness)
    day_of_haibanhoishokus_day = day_of_haibanhoishokus.pluck(:day)
    day_of_haibanhoishoku_day = day_of_haibanhoishokus_day.map do |day_of_haibanhoishoku_day|
      "Day" + day_of_haibanhoishoku_day.to_s + "(移植日)"
    end
    day_of_haibanhoishokus_e2 = day_of_haibanhoishokus.pluck(:e2)
    day_of_haibanhoishokus_fsh = day_of_haibanhoishokus.pluck(:fsh)
    day_of_haibanhoishokus_lh = day_of_haibanhoishokus.pluck(:lh)
    day_of_haibanhoishokus_p4 = day_of_haibanhoishokus.pluck(:p4)

    haibanhoishoku_hormones = @report.haibanhoishoku_hormones.order(bt: "ASC")
    @haibanhoishoku_hormones = haibanhoishoku_hormones.pluck(:bt, :hcg, :e2, :fsh, :lh, :p4).flatten!
    haibanhoishoku_hormones_bts = haibanhoishoku_hormones.map { |b| b[:bt] }
    haibanhoishoku_hormones_bt = haibanhoishoku_hormones_bts.map do |d|
      if @report.embryo_stage == 1
        "ET" + d.to_s
      elsif @report.embryo_stage == 2
        "BT" + d.to_s
      else
        "D" + d.to_s
      end
    end
    gon.ishoku_hormones_et_bt = haibanhoishoku_hormones_bt
    labels = before_ishoku_hormones_day << day_of_haibanhoishoku_day << haibanhoishoku_hormones_bt
    gon.labels = labels.flatten

    ishoku_hormones_e2 = haibanhoishoku_hormones.map { |e| e[:e2] }
    ishoku_hormones_bihe2 = before_ishoku_hormones_e2 << day_of_haibanhoishokus_e2 << ishoku_hormones_e2
    gon.ishoku_hormones_e2 = ishoku_hormones_bihe2.flatten

    ishoku_hormones_fsh = haibanhoishoku_hormones.map { |f| f[:fsh] }
    ishoku_hormones_bihfsh = before_ishoku_hormones_fsh << day_of_haibanhoishokus_fsh << ishoku_hormones_fsh
    gon.ishoku_hormones_fsh = ishoku_hormones_bihfsh.flatten

    ishoku_hormones_lh = haibanhoishoku_hormones.map { |l| l[:lh] }
    ishoku_hormones_bihlh = before_ishoku_hormones_lh << day_of_haibanhoishokus_lh << ishoku_hormones_lh
    gon.ishoku_hormones_lh = ishoku_hormones_bihlh.flatten

    ishoku_hormones_p4 = haibanhoishoku_hormones.map { |p| p[:p4] }
    ishoku_hormones_bihp4 = before_ishoku_hormones_p4 << day_of_haibanhoishokus_p4 << ishoku_hormones_p4
    gon.ishoku_hormones_p4 = ishoku_hormones_bihp4.flatten

    gon.ishoku_hormones_hcg = haibanhoishoku_hormones.map { |h| h[:hcg] }
  end

  def new
    @report = Report.new
    @report.itinerary_of_choosing_a_clinics.build
    @report.special_inspections.build
    @report.unsuccessful_sairan_cycles.build
    @report.unsuccessful_ishoku_cycles.build
    
    # ホルモン値
    @report.sairan_hormones.build
    @report.day_of_sairans.build
    @report.before_ishoku_hormones.build
    @report.day_of_haibanhoishokus.build
    @report.haibanhoishoku_hormones.build

  end

  def molding(materials)
    list = materials.map do |material|
      material.gsub(/(\s|　)+/, '')
    end
  end

  def create
    @report = Report.new(report_params)
    @report.user_id = current_user.id

    @report.normalize_for_create_embryo_stage
    @report.normalize_for_credit_card_validity

    if params[:status1] || params[:status2]
      @report.status = "nonreleased"
    else
      @report.status = "released"
    end

    # tag_name = params[:tag_name].split(",")
    # tag_list = molding(tag_name)
    # tag_ids = params[:report][:tag_ids]
    # tag_ids.each do |tag_id|
    #   if tag_id.blank?
    #     next
    #   end
    #   tag = Tag.find(tag_id)
    #   tag_list << tag.tag_name
    # end
    # tag_list = tag_list.uniq

    respond_to do |format|
      if params[:back]
        format.html { render :new }
      elsif @report.save
        # @report.save_tags(tag_list)
        if params[:status1].present?
          format.html { redirect_to report_path(@report), notice: 'レポコを保存しました。' }
          format.json { render :show, status: :created, location: @report }
        else
          format.html { redirect_to report_path(@report), notice: 'レポコを作成しました。' }
          format.json { render :show, status: :created, location: @report }
        end
      else
        # @report = Report.new(report_params)
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    if @report.user != current_user
      redirect_to root_path, alert: '編集権限がありません' 
      return
    end

    if @report.itinerary_of_choosing_a_clinics.count == 0
      @report.itinerary_of_choosing_a_clinics.build
    end

    if @report.special_inspections.count == 0
      @report.special_inspections.build
    end

    if @report.unsuccessful_sairan_cycles.count == 0
      @report.unsuccessful_sairan_cycles.build
    end

    if @report.unsuccessful_ishoku_cycles.count == 0
      @report.unsuccessful_ishoku_cycles.build
    end

    # ホルモン値
    if @report.sairan_hormones.count == 0
      @report.sairan_hormones.build
    end
    if @report.day_of_sairans.count == 0
      @report.day_of_sairans.build
    end
    if @report.before_ishoku_hormones.count == 0
      @report.before_ishoku_hormones.build
    end
    if @report.day_of_haibanhoishokus.count == 0
      @report.day_of_haibanhoishokus.build
    end
    if @report.haibanhoishoku_hormones.count == 0
      @report.haibanhoishoku_hormones.build
    end
  end

  def release
    report =  Report.find(params[:id])
    report.released! unless report.released?
    redirect_to report_path(report), notice: 'レポコを公開しました'
  end

  def nonrelease
    report =  Report.find(params[:id])
    report.nonreleased! unless report.nonreleased?
    redirect_to report_path(report), notice: 'レポコを非公開にしました'
  end

  def update
    if @report.user != current_user
      redirect_to root_path, alert: '編集権限がありません' 
      return
    end

    @report.normalize_for_credit_card_validity

    if params[:status1] || params[:status2]
      @report.status = "nonreleased"
    end

    if @report.status.blank?
      @report.status = "released"
    end

    respond_to do |format|
      if params[:back]
        format.html { render :edit }
      elsif @report.update(report_params)
        if @report.status == "nonreleased"
          format.html { redirect_to report_path(@report), notice: 'レポコの下書きを更新しました。' }
          format.json { render :show, status: :created, location: @report }
        else
          format.html { redirect_to report_path(@report), notice: 'レポコを更新しました。' }
          format.json { render :show, status: :created, location: @report }
        end
      else
        # @report.update_attributes(report_params)
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @report.user != current_user
      redirect_to root_path, alert: '削除権限がありません' 
      return
    end
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'レポコを削除しました。' }
    end
  end
  
  def address_cities_select
    @cities = City.where(prefecture_id: params[:prefecture_id]).order(:id)
    render partial: 'address/address_cities'
  end
  
  private
  
  def set_report
    @report = Report.find(params[:id])
  end
  
  def report_params
    params.require(:report).permit(
      :status,
      :clinic_id,
      :prefecture_id,
      :prefecture_at_the_time_status,
      :city_id,
      :city_at_the_time_status,
      :current_state,
      :work_style,
      :work_style_status,
      :switching_work_styles,
      :fertility_treatment_number,
      :types_of_fertilization_methods,
      :details_of_icsi,
      :transplant_method,
      :treatment_end_age,
      :age_of_partner_at_end_of_treatment,
      :year_of_treatment_end,
      :treatment_period,
      :male_infertility,
      :level_of_male_infertility,
      :fuiku,
      :number_of_clinics,
      :period_of_time_spent_traveling,
      :reasons_for_choosing_this_clinic,
      :reason_for_transfer,
      :amh,
      :total_number_of_sairan,
      :number_of_visits_before_sairan,
      :sairan_age,
      :type_of_ovarian_stimulation,
      :use_of_anesthesia,
      :selection_of_anesthesia_type,
      :number_of_eggs_collected,
      :egg_m2,
      :egg_m1,
      :egg_gv,
      :number_of_fertilized_eggs,
      :number_of_transferable_embryos,
      :number_of_unfrozen_embryos,
      :number_of_frozen_pronuclear_embryos,
      :number_of_frozen_early_embryos,
      :number_of_frozen_blastocysts,
      :embryo_stage,
      :total_number_of_eggs_transplanted,
      :total_number_of_transplants,
      :number_of_visits_before_ishoku,
      :ishoku_age,
      :ishoku_type,
      :early_embryo_grade,
      :blastocyst_grade1,
      :blastocyst_grade2,
      :culture_days,
      :choran,
      :cost,
      :explanation_of_costs,
      :sairan_cost,
      :ishoku_cost,
      :credit_card_validity,
      :creditcards_can_be_used_from_more_than,
      :doctor_quality,
      :staff_quality,
      :impression_of_technology,
      :impression_of_price,
      :average_waiting_time2,
      :comfort_of_space,
      :average_waiting_time,
      :free_wifi,
      :possible_to_wait_outside_cl,
      :clinic_review,
      :content,
      :title,
      f_funin_factor_ids: [],
      fuiku_inspection_ids: [],
      itinerary_of_choosing_a_clinics_attributes: [:id, :order_of_transfer, :public_status, :clinic_id, :_destroy],
      cl_selection_ids: [],
      special_inspections_attributes: [:id, :name, :place, :cost, :memo, :_destroy],
      unsuccessful_sairan_cycles_attributes: [:id, :un_sairan_number, :un_sairan_age, :un_sairan_type_of_ovarian_stimulation, :un_sairan_number_of_eggs_collected, :un_sairan_number_of_fertilized_eggs,:un_sairan_number_of_transferable_embryos, :un_sairan_number_of_frozen_eggs, :un_sairan_memo, :_destroy],
      transfer_option_ids: [],
      pg_eplenishment_ids: [],
      unsuccessful_ishoku_cycles_attributes: [:id, :un_ishoku_number, :un_ishoku_age, :un_ishoku_transplant_method, :un_ishoku_type, :un_ishoku_memo, :_destroy],

      day_of_sairans_attributes: [:id, :day, :e2, :fsh, :lh, :p4, :_destroy],
      day_of_shokihaiishokus_attributes: [:id, :day, :e2, :fsh, :lh, :p4, :endometrial_thickness, :_destroy],
      day_of_haibanhoishokus_attributes: [:id, :day, :e2, :fsh, :lh, :p4, :endometrial_thickness, :_destroy],
      sairan_hormones_attributes: [:id, :day, :e2, :fsh, :lh, :p4, :_destroy],
      before_ishoku_hormones_attributes: [:id, :day, :e2, :fsh, :lh, :p4, :_destroy],
      shokihaiishoku_hormones_attributes: [:id, :et, :e2, :fsh, :lh, :p4, :hcg, :_destroy],
      haibanhoishoku_hormones_attributes: [:id, :bt, :e2, :fsh, :lh, :p4, :hcg, :_destroy],
      )
    end
end