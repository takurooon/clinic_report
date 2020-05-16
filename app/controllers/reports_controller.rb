class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]

  def index
    @reports = params[:tag_id].present? ? Tag.find(params[:tag_id]).reports : Report.all
    @reports = Report.released.order("created_at DESC").page(params[:page]).per(10)
    @toptags = Tag.find(ReportTag.group(:tag_id).order('count(tag_id) desc').limit(5).pluck(:tag_id))
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

    @annual_income_status = Report.find(params[:id]).annual_income_status
    @household_net_income_status = Report.find(params[:id]).household_net_income_status

    itinerary_of_choosing_a_clinics = @report.itinerary_of_choosing_a_clinics.order(order_of_transfer: "desc")
    clinics = itinerary_of_choosing_a_clinics.map { |i| i[:clinic_id] }
    @clinics = clinics.map do |c|
      Clinic.find(c).name
    end

    @special_inspection_era = @report.special_inspections.where(name: 1)
    @special_inspection_emma = @report.special_inspections.where(name: 2)
    @special_inspection_alice = @report.special_inspections.where(name: 3)
    @special_inspection_trio = @report.special_inspections.where(name: 4)
    @special_inspection_erpeak = @report.special_inspections.where(name: 5)
    @special_inspection_endometrial_biopsy = @report.special_inspections.where(name: 6)
    @special_inspection_intrauterine_flora = @report.special_inspections.where(name: 7)
    @special_inspection_bce = @report.special_inspections.where(name: 8)
    @special_inspection_hysteroscopy = @report.special_inspections.where(name: 9)
    @special_inspection_chromosome = @report.special_inspections.where(name: 10)
    @special_inspection_ca125 = @report.special_inspections.where(name: 11)
    @special_inspection_mri = @report.special_inspections.where(name: 12)
    @special_inspection_vitamin_d = @report.special_inspections.where(name: 13)
    @special_inspection_copper_zinc = @report.special_inspections.where(name: 14)
    @special_inspection_kruger = @report.special_inspections.where(name: 15)
    @special_inspection_other_inspection = @report.special_inspections.where(name: 99)

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

    day_of_shokihaiishokus = @report.day_of_shokihaiishokus
    @day_of_shokihaiishokus = day_of_shokihaiishokus.pluck(:day, :e2, :fsh, :lh, :p4).flatten!
    @shokihaiishokus_endometrial_thickness = day_of_shokihaiishokus.pluck(:endometrial_thickness)
    day_of_shokihaiishokus_day = day_of_shokihaiishokus.pluck(:day)
    day_of_shokihaiishoku_day = day_of_shokihaiishokus_day.map do |day_of_shokihaiishoku_day|
      "Day" + day_of_shokihaiishoku_day.to_s + "(移植日)"
    end
    day_of_shokihaiishokus_e2 = day_of_shokihaiishokus.pluck(:e2)
    day_of_shokihaiishokus_fsh = day_of_shokihaiishokus.pluck(:fsh)
    day_of_shokihaiishokus_lh = day_of_shokihaiishokus.pluck(:lh)
    day_of_shokihaiishokus_p4 = day_of_shokihaiishokus.pluck(:p4)

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

    if @report.embryo_stage == 1
      shokihaiishoku_hormones = @report.shokihaiishoku_hormones.order(et: "ASC")
      @shokihaiishoku_hormones = shokihaiishoku_hormones.pluck(:et, :hcg, :e2, :fsh, :lh, :p4).flatten!
      shokihaiishoku_hormones_ets = shokihaiishoku_hormones.map { |et| et[:et] }
      shokihaiishoku_hormones_et = shokihaiishoku_hormones_ets.map do |d|
        "ET" + d.to_s
      end
      gon.ishoku_hormones_et_bt = shokihaiishoku_hormones_et
      labels = before_ishoku_hormones_day << day_of_shokihaiishoku_day << shokihaiishoku_hormones_et
      gon.labels = labels.flatten

      ishoku_hormones_e2 = shokihaiishoku_hormones.map { |e| e[:e2] }
      ishoku_hormones_bihe2 = before_ishoku_hormones_e2 << day_of_shokihaiishokus_e2 << ishoku_hormones_e2
      gon.ishoku_hormones_e2 = ishoku_hormones_bihe2.flatten

      ishoku_hormones_fsh = shokihaiishoku_hormones.map { |f| f[:fsh] }
      ishoku_hormones_bihfsh = before_ishoku_hormones_fsh << day_of_shokihaiishokus_fsh << ishoku_hormones_fsh
      gon.ishoku_hormones_fsh = ishoku_hormones_bihfsh.flatten

      ishoku_hormones_lh = shokihaiishoku_hormones.map { |l| l[:lh] }
      ishoku_hormones_bihlh = before_ishoku_hormones_lh << day_of_shokihaiishokus_lh << ishoku_hormones_lh
      gon.ishoku_hormones_lh = ishoku_hormones_bihlh.flatten

      ishoku_hormones_p4 = shokihaiishoku_hormones.map { |p| p[:p4] }
      ishoku_hormones_bihp4 = before_ishoku_hormones_p4 << day_of_shokihaiishokus_p4 << ishoku_hormones_p4
      gon.ishoku_hormones_p4 = ishoku_hormones_bihp4.flatten

      gon.ishoku_hormones_hcg = shokihaiishoku_hormones.map { |h| h[:hcg] }

    elsif @report.embryo_stage == 2
      haibanhoishoku_hormones = @report.haibanhoishoku_hormones.order(bt: "ASC")
      @haibanhoishoku_hormones = haibanhoishoku_hormones.pluck(:bt, :hcg, :e2, :fsh, :lh, :p4).flatten!
      haibanhoishoku_hormones_bts = haibanhoishoku_hormones.map { |b| b[:bt] }
      haibanhoishoku_hormones_bt = haibanhoishoku_hormones_bts.map do |d|
        "BT" + d.to_s
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
    else
    end

    gon.clinic_name = @report.clinic.name
    gon.doctor_quality = @report.doctor_quality
    gon.staff_quality = @report.staff_quality
    gon.impression_of_technology = @report.impression_of_technology
    gon.impression_of_price = @report.impression_of_price
    gon.comfort_of_space = @report.comfort_of_space
    awt = @report.average_waiting_time
    @awt = awt
    if awt.present?
      if awt <= 2
        average_waiting_time = 1
      elsif awt <= 4
        average_waiting_time = 2
      elsif awt <= 6
        average_waiting_time = 3
      elsif awt <= 8
        average_waiting_time = 4
      else
        average_waiting_time = 5
      end
    else
      average_waiting_time = 0
    end
    gon.clinic_evaluation = []
    gon.clinic_evaluation << @report.doctor_quality << @report.staff_quality << @report.impression_of_technology << @report.impression_of_price << average_waiting_time << @report.comfort_of_space
  end

  def new
    @report = Report.new
    @all_tag_list = Tag.all.pluck(:tag_name)
    @report.itinerary_of_choosing_a_clinics.build
    @report.sairan_hormones.build
    @report.day_of_sairans.build
    @report.before_ishoku_hormones.build
    @report.day_of_shokihaiishokus.build
    @report.day_of_haibanhoishokus.build
    @report.shokihaiishoku_hormones.build
    @report.haibanhoishoku_hormones.build
    @report.special_inspections.build
  end

  
  # def confirm
  #   flash[:alert] = "まだ投稿は完了していません。必須項目の「クリニック」と「お住まい(非公開設定可)」は選択済みですか？"
  #   if params[:id].blank?
  #     @report = Report.new(report_params_for_confirm)
  #   else
  #     @report = Report.find(params[:id])
  #     @report.attributes = report_params_for_confirm
  #   end

  #   if params[:temp].blank?
  #     @report.status = params[:status2]
  #   else
  #     @report.status = params[:status1]
  #   end

  #   if @report.status.blank?
  #     @report.status = "released"
  #   end

  #   @i_name = params[:i_name]
  #   @fif_name = params[:fif_name]
  #   @mif_name = params[:mif_name]
  #   @fd_name = params[:fd_name]
  #   @md_name = params[:md_name]
  #   @fs_name = params[:fs_name]
  #   @ms_name = params[:ms_name] 
  #   @sm_name = params[:sm_name] 
  #   @tm_name = params[:tm_name]
  #   @to_name = params[:to_name]
  #   @oe_name = params[:oe_name]
  #   @supplement_name = params[:supplement_name]
  #   @sod_scope = params[:sod_scope]
  #   @tag_name = params[:tag_name]
  # end

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

    # if params[:temp].blank?
    #   @report.status = params[:status2]
    # else
    #   @report.status = params[:status1]
    # end

    if params[:status1] || params[:status2]
      @report.status = "nonreleased"
    else
      @report.status = "released"
    end

    # ssm_name = params[:ssm_name].split(",")
    # ssm_list = molding(ssm_name)
    # ssm_ids = params[:report][:s_selection_method_ids]
    # ssm_ids.each do |ssm_id|
    #   if ssm_id.blank?
    #     next
    #   end
    #   ssm = SSelectionMethod.find(ssm_id)
    #   ssm_list << ssm.name
    # end
    # ssm_list = ssm_list.uniq

    # i_name = params[:i_name].split(",")
    # i_list = molding(i_name)
    # i_ids = params[:report][:inspection_ids]
    # i_ids.each do |i_id|
    #   if i_id.blank?
    #     next
    #   end
    #   i = Inspection.find(i_id)
    #   i_list << i.name
    # end
    # i_list = i_list.uniq

    # fif_name = params[:fif_name].split(",")
    # fif_list = molding(fif_name)
    # fif_ids = params[:report][:f_infertility_factor_ids]
    # fif_ids.each do |fif_id|
    #   if fif_id.blank?
    #     next
    #   end
    #   fif = FInfertilityFactor.find(fif_id)
    #   fif_list << fif.name
    # end
    # fif_list = fif_list.uniq

    # mif_name = params[:mif_name].split(",")
    # mif_list = molding(mif_name)
    # mif_ids = params[:report][:m_infertility_factor_ids]
    # mif_ids.each do |mif_id|
    #   if mif_id.blank?
    #     next
    #   end
    #   mif = MInfertilityFactor.find(mif_id)
    #   mif_list << mif.name
    # end
    # mif_list = mif_list.uniq

    # fd_name = params[:fd_name].split(",")
    # fd_list = molding(fd_name)
    # fd_ids = params[:report][:f_disease_ids]
    # fd_ids.each do |fd_id|
    #   if fd_id.blank?
    #     next
    #   end
    #   fd = FDisease.find(fd_id)
    #   fd_list << fd.name
    # end
    # fd_list = fd_list.uniq

    # md_name = params[:md_name].split(",")
    # md_list = molding(md_name)
    # md_ids = params[:report][:m_disease_ids]
    # md_ids.each do |md_id|
    #   if md_id.blank?
    #     next
    #   end
    #   md = MDisease.find(md_id)
    #   md_list << md.name
    # end
    # md_list = md_list.uniq

    # fs_name = params[:fs_name].split(",")
    # fs_list = molding(fs_name)
    # fs_ids = params[:report][:f_surgery_ids]
    # fs_ids.each do |fs_id|
    #   if fs_id.blank?
    #     next
    #   end
    #   fs = FSurgery.find(fs_id)
    #   fs_list << fs.name
    # end
    # fs_list = fs_list.uniq

    # ms_name = params[:ms_name].split(",")
    # ms_list = molding(ms_name)
    # ms_ids = params[:report][:m_surgery_ids]
    # ms_ids.each do |ms_id|
    #   if ms_id.blank?
    #     next
    #   end
    #   ms = MSurgery.find(ms_id)
    #   ms_list << ms.name
    # end
    # ms_list = ms_list.uniq

    # sm_name = params[:sm_name].split(",")
    # sm_list = molding(sm_name)
    # sm_ids = params[:report][:sairan_medicine_ids]
    # sm_ids.each do |sm_id|
    #   if sm_id.blank?
    #     next
    #   end
    #   sm = SairanMedicine.find(sm_id)
    #   sm_list << sm.name
    # end
    # sm_list = sm_list.uniq

    # tm_name = params[:tm_name].split(",")
    # tm_list = molding(tm_name)
    # tm_ids = params[:report][:transfer_medicine_ids]
    # tm_ids.each do |tm_id|
    #   if tm_id.blank?
    #     next
    #   end
    #   tm = TransferMedicine.find(tm_id)
    #   tm_list << tm.name
    # end
    # tm_list = tm_list.uniq

    # to_name = params[:to_name].split(",")
    # to_list = molding(to_name)
    # to_ids = params[:report][:transfer_option_ids]
    # to_ids.each do |to_id|
    #   if to_id.blank?
    #     next
    #   end
    #   to = TransferOption.find(to_id)
    #   to_list << to.name
    # end
    # to_list = to_list.uniq

    # oe_name = params[:oe_name].split(",")
    # oe_list = molding(oe_name)
    # oe_ids = params[:report][:other_effort_ids]
    # oe_ids.each do |oe_id|
    #   if oe_id.blank?
    #     next
    #   end
    #   oe = OtherEffort.find(oe_id)
    #   oe_list << oe.name
    # end
    # to_list = to_list.uniq

    # supplement_name = params[:supplement_name].split(",")
    # supplement_list = molding(supplement_name)
    # supplement_ids = params[:report][:supplement_ids]
    # supplement_ids.each do |supplement_id|
    #   if supplement_id.blank?
    #     next
    #   end
    #   supplement = Supplement.find(supplement_id)
    #   supplement_list << supplement.name
    # end
    # supplement_list = supplement_list.uniq

    # sod_name = params[:sod_scope].split(",")
    # sod_list = molding(sod_name)
    # sod_ids = params[:report][:scope_of_disclosure_ids]
    # sod_ids.each do |sod_id|
    #   if sod_id.blank?
    #     next
    #   end
    #   sod = ScopeOfDisclosure.find(sod_id)
    #   sod_list << sod.scope
    # end
    # sod_list = sod_list.uniq

    tag_name = params[:tag_name].split(",")
    tag_list = molding(tag_name)
    tag_ids = params[:report][:tag_ids]
    tag_ids.each do |tag_id|
      if tag_id.blank?
        next
      end
      tag = Tag.find(tag_id)
      tag_list << tag.tag_name
    end
    tag_list = tag_list.uniq

    respond_to do |format|
      if params[:back]
        format.html { render :new }
      elsif @report.save
        # @report.save_i(i_list)
        # @report.save_fifs(fif_list)
        # @report.save_mifs(mif_list)
        # @report.save_fds(fd_list)
        # @report.save_mds(md_list)
        # @report.save_fss(fs_list)
        # @report.save_mss(ms_list)
        # @report.save_sms(sm_list)
        # @report.save_tms(tm_list)
        # @report.save_tos(to_list)
        # @report.save_oes(oe_list)
        # @report.save_supplements(supplement_list)
        # @report.save_sods(sod_list)
        @report.save_tags(tag_list)
        format.html { redirect_to report_path(@report), notice: 'レポコを作成しました。' }
        format.json { render :show, status: :created, location: @report }
      else
        @report = Report.new(report_params)
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

    @tag_list = @report.tags.pluck(:tag_name).join(",")

    if @report.itinerary_of_choosing_a_clinics.count == 0
      @report.itinerary_of_choosing_a_clinics.build
    end

    if @report.sairan_hormones.count == 0
      @report.sairan_hormones.build
    end

    if @report.day_of_sairans.count == 0
      @report.day_of_sairans.build
    end

    if @report.before_ishoku_hormones.count == 0
      @report.before_ishoku_hormones.build
    end

    if @report.day_of_shokihaiishokus.count == 0
      @report.day_of_shokihaiishokus.build
    end

    if @report.day_of_haibanhoishokus.count == 0
      @report.day_of_haibanhoishokus.build
    end

    if @report.shokihaiishoku_hormones.count == 0
      @report.shokihaiishoku_hormones.build
    end

    if @report.haibanhoishoku_hormones.count == 0
      @report.haibanhoishoku_hormones.build
    end

    if @report.special_inspections.count == 0
      @report.special_inspections.build
    end
  end

  def release
    report =  Report.find(params[:id])
    report.released! unless report.released?
    redirect_to report_path(report), notice: 'このレポコを公開しました'
  end

  def nonrelease
    report =  Report.find(params[:id])
    report.nonreleased! unless report.nonreleased?
    redirect_to report_path(report), notice: 'このレポコを非公開にしました'
  end

  def update
    if @report.user != current_user
      redirect_to root_path, alert: '編集権限がありません' 
      return
    end

    # @report.normalize_for_update_embryo_stage
    @report.normalize_for_credit_card_validity

    # if params[:temp].blank?
    #   @report.status = params[:status2]
    # else
    #   @report.status = params[:status1]
    # end

    if params[:status1] || params[:status2]
      @report.status = "nonreleased"
    end

    if @report.status.blank?
      @report.status = "released"
    end

    # ssm_name = params[:ssm_name].split(",")
    # ssm_list = molding(ssm_name)
    # ssm_ids = params[:report][:s_selection_method_ids]
    # ssm_ids.each do |ssm_id|
    #   if ssm_id.blank?
    #     next
    #   end
    #   ssm = SSelectionMethod.find(ssm_id)
    #   ssm_list << ssm.name
    # end
    # ssm_list = ssm_list.uniq

    # i_name = params[:i_name].split(",")
    # i_list = molding(i_name)
    # i_ids = params[:report][:inspection_ids]
    # i_ids.each do |i_id|
    #   if i_id.blank?
    #     next
    #   end
    #   i = Inspection.find(i_id)
    #   i_list << i.name
    # end
    # i_list = i_list.uniq

    # fif_name = params[:fif_name].split(",")
    # fif_list = molding(fif_name)
    # fif_ids = params[:report][:f_infertility_factor_ids]
    # fif_ids.each do |fif_id|
    #   if fif_id.blank?
    #     next
    #   end
    #   fif = FInfertilityFactor.find(fif_id)
    #   fif_list << fif.name
    # end
    # fif_list = fif_list.uniq

    # mif_name = params[:mif_name].split(",")
    # mif_list = molding(mif_name)
    # mif_ids = params[:report][:m_infertility_factor_ids]
    # mif_ids.each do |mif_id|
    #   if mif_id.blank?
    #     next
    #   end
    #   mif = MInfertilityFactor.find(mif_id)
    #   mif_list << mif.name
    # end
    # mif_list = mif_list.uniq

    # fd_name = params[:fd_name].split(",")
    # fd_list = molding(fd_name)
    # fd_ids = params[:report][:f_disease_ids]
    # fd_ids.each do |fd_id|
    #   if fd_id.blank?
    #     next
    #   end
    #   fd = FDisease.find(fd_id)
    #   fd_list << fd.name
    # end
    # fd_list = fd_list.uniq

    # md_name = params[:md_name].split(",")
    # md_list = molding(md_name)
    # md_ids = params[:report][:m_disease_ids]
    # md_ids.each do |md_id|
    #   if md_id.blank?
    #     next
    #   end
    #   md = MDisease.find(md_id)
    #   md_list << md.name
    # end
    # md_list = md_list.uniq

    # fs_name = params[:fs_name].split(",")
    # fs_list = molding(fs_name)
    # fs_ids = params[:report][:f_surgery_ids]
    # fs_ids.each do |fs_id|
    #   if fs_id.blank?
    #     next
    #   end
    #   fs = FSurgery.find(fs_id)
    #   fs_list << fs.name
    # end
    # fs_list = fs_list.uniq

    # ms_name = params[:ms_name].split(",")
    # ms_list = molding(ms_name)
    # ms_ids = params[:report][:m_surgery_ids]
    # ms_ids.each do |ms_id|
    #   if ms_id.blank?
    #     next
    #   end
    #   ms = MSurgery.find(ms_id)
    #   ms_list << ms.name
    # end
    # ms_list = ms_list.uniq

    # sm_name = params[:sm_name].split(",")
    # sm_list = molding(sm_name)
    # sm_ids = params[:report][:sairan_medicine_ids]
    # sm_ids.each do |sm_id|
    #   if sm_id.blank?
    #     next
    #   end
    #   sm = SairanMedicine.find(sm_id)
    #   sm_list << sm.name
    # end
    # sm_list = sm_list.uniq

    # tm_name = params[:tm_name].split(",")
    # tm_list = molding(tm_name)
    # tm_ids = params[:report][:transfer_medicine_ids]
    # tm_ids.each do |tm_id|
    #   if tm_id.blank?
    #     next
    #   end
    #   tm = TransferMedicine.find(tm_id)
    #   tm_list << tm.name
    # end
    # tm_list = tm_list.uniq

    # to_name = params[:to_name].split(",")
    # to_list = molding(to_name)
    # to_ids = params[:report][:transfer_option_ids]
    # to_ids.each do |to_id|
    #   if to_id.blank?
    #     next
    #   end
    #   to = TransferOption.find(to_id)
    #   to_list << to.name
    # end
    # to_list = to_list.uniq

    # oe_name = params[:oe_name].split(",")
    # oe_list = molding(oe_name)
    # oe_ids = params[:report][:other_effort_ids]
    # oe_ids.each do |oe_id|
    #   if oe_id.blank?
    #     next
    #   end
    #   oe = OtherEffort.find(oe_id)
    #   oe_list << oe.name
    # end
    # to_list = to_list.uniq

    # supplement_name = params[:supplement_name].split(",")
    # supplement_list = molding(supplement_name)
    # supplement_ids = params[:report][:supplement_ids]
    # supplement_ids.each do |supplement_id|
    #   if supplement_id.blank?
    #     next
    #   end
    #   supplement = Supplement.find(supplement_id)
    #   supplement_list << supplement.name
    # end
    # supplement_list = supplement_list.uniq

    # sod_name = params[:sod_scope].split(",")
    # sod_list = molding(sod_name)
    # sod_ids = params[:report][:scope_of_disclosure_ids]
    # sod_ids.each do |sod_id|
    #   if sod_id.blank?
    #     next
    #   end
    #   sod = ScopeOfDisclosure.find(sod_id)
    #   sod_list << sod.scope
    # end
    # sod_list = sod_list.uniq

    tag_name = params[:tag_name].split(",")
    tag_list = molding(tag_name)
    tag_ids = params[:report][:tag_ids]
    tag_ids.each do |tag_id|
      if tag_id.blank?
        next
      end
      tag = Tag.find(tag_id)
      tag_list << tag.tag_name
    end
    tag_list = tag_list.uniq

    # hash = params[:report][:day_of_haibanhoishokus_attributes]
    # hash.each{|key, value|
    #   print(key + "=>", value)
    #   params[:report][:day_of_haibanhoishokus_attributes][key][:e2] = ""
    # }

    # 検証必須↓
    # if params[:report][:embryo_stage] == 1
    #   params[:report][:blastocyst_grade1] = {}
    #   params[:report][:blastocyst_grade2] = {}
    #   params[:report][:day_of_haibanhoishokus_attributes] = {}
    #   params[:report][:haibanhoishoku_hormones_attributes] = {}
    # elsif params[:embryo_stage] == 2
    #   params[:report][:early_embryo_grade] = {}
    #   params[:report][:day_of_shokihaiishokus] = {}
    #   params[:report][:shokihaiishoku_hormones] = {}
    # else
    #   params[:report][:early_embryo_grade] = {}
    #   params[:report][:blastocyst_grade1] = {}
    #   params[:report][:blastocyst_grade2] = {}
    #   params[:report][:day_of_shokihaiishokus] = {}
    #   params[:report][:shokihaiishoku_hormones] = {}
    #   params[:report][:day_of_haibanhoishokus_attributes] = {}
    #   params[:report][:haibanhoishoku_hormones_attributes] = {}
    # end

    respond_to do |format|
      if params[:back]
        format.html { render :edit }
      elsif @report.update(report_params)
        # @report.save_i(i_list)
        # @report.save_fifs(fif_list)
        # @report.save_mifs(mif_list)
        # @report.save_fds(fd_list)
        # @report.save_mds(md_list)
        # @report.save_fss(fs_list)
        # @report.save_mss(ms_list)
        # @report.save_sms(sm_list)
        # @report.save_tms(tm_list)
        # @report.save_tos(to_list)
        # @report.save_oes(oe_list)
        # @report.save_supplements(supplement_list)
        # @report.save_sods(sod_list)
        @report.save_tags(tag_list)
        format.html { redirect_to report_path(@report), notice: 'レポコを更新しました。' }
        format.json { render :show, status: :created, location: @report }
      else
        @report.attributes(report_params)
        format.html { render :new }
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

    # def report_params_for_confirm
    #   params.require(:report).permit(
    #     :current_state,
    #     :clinic_id,
    #     :prefecture_id,
    #     :prefecture_at_the_time_status,
    #     :city_id,
    #     :city_at_the_time_status,
    #     :number_of_clinics,
    #     :clinic_selection_criteria,
    #     :briefing_session,
    #     :reasons_for_choosing_this_clinic,
    #     :year_of_treatment_end,
    #     :fertility_treatment_number,
    #     :types_of_fertilization_methods,
    #     :details_of_icsi,
    #     :transplant_method,
    #     :treatment_start_age,
    #     :first_age_to_start,
    #     :treatment_end_age,
    #     :age_of_partner_at_end_of_treatment,
    #     :treatment_period,
    #     :number_of_aih,
    #     :inspection_supplementary_explanation,
    #     :amh,
    #     :bmi,
    #     :smoking,
    #     :types_of_eggs_and_sperm,
    #     :description_of_eggs_and_sperm_used,
    #     :type_of_ovarian_stimulation,
    #     :type_of_sairan_cycle,
    #     :notes_on_type_of_sairan_cycle,
    #     :use_of_anesthesia,
    #     :selection_of_anesthesia_type,
    #     :total_number_of_sairan,
    #     :all_number_of_sairan,
    #     :number_of_eggs_collected,
    #     :number_of_fertilized_eggs,
    #     :number_of_transferable_embryos,
    #     :number_of_frozen_eggs,
    #     :egg_maturity,
    #     :ova_with_ivm,
    #     :embryo_culture_days,
    #     :embryo_stage,
    #     :early_embryo_grade,
    #     :early_embryo_grade_supplementary_explanation,
    #     :blastocyst_grade1,
    #     :blastocyst_grade1_supplementary_explanation,
    #     :blastocyst_grade2,
    #     :blastocyst_grade2_supplementary_explanation,
    #     :explanation_and_impression_about_sairan,
    #     :about_causes_of_infertility,
    #     :semen_volume,
    #     :semen_concentration,
    #     :sperm_advance_rate,
    #     :sperm_motility,
    #     :probability_of_normal_morphology_of_sperm,
    #     :total_amount_of_sperm,
    #     :sperm_description,
    #     :number_of_miscarriages,
    #     :number_of_stillbirths,
    #     :fuiku,
    #     :fuiku_supplementary_explanation,
    #     :pgt1,
    #     :pgt1_status,
    #     :pgt2,
    #     :pgt2_status,
    #     :pgt_supplementary_explanation,
    #     :pgt_supplementary_explanation_status,
    #     :total_number_of_transplants,
    #     :total_number_of_eggs_transplanted,
    #     :all_number_of_transplants,
    #     :number_of_eggs_stored,
    #     :frozen_embryo_storage_cost,
    #     :explanation_of_frozen_embryo_storage_cost,
    #     :explanation_and_impression_about_ishoku,
    #     :adoption,
    #     :other_effort_cost,
    #     :other_effort_supplementary_explanation,
    #     :supplement_cost,
    #     :supplement_supplementary_explanation,
    #     :sairan_cost,
    #     :sairan_cost_explanation,
    #     :ishoku_cost,
    #     :ishoku_cost_explanation,
    #     :cost,
    #     :explanation_of_cost,
    #     :all_cost,
    #     :number_of_times_the_grant_was_received,
    #     :all_grant_amount,
    #     :supplementary_explanation_of_grant,
    #     :credit_card_validity,
    #     :creditcards_can_be_used_from_more_than,
    #     :average_waiting_time,
    #     :reservation_method,
    #     :online_consultation,
    #     :online_consultation_details,
    #     :period_of_time_spent_traveling,
    #     :work_style,
    #     :work_style_status,
    #     :industry_type,
    #     :industry_type_status,
    #     :private_or_listed_company,
    #     :private_or_listed_company_status,
    #     :domestic_or_foreign_capital,
    #     :domestic_or_foreign_capital_status,
    #     :capital_size,
    #     :capital_size_status,
    #     :department,
    #     :department_status,
    #     :position,
    #     :position_status,
    #     :number_of_employees,
    #     :number_of_employees_status,
    #     :treatment_support_system,
    #     :suspended_or_retirement_job,
    #     :annual_income,
    #     :annual_income_status,
    #     :household_net_income,
    #     :household_net_income_status,
    #     :about_work_and_working_style,
    #     :title,
    #     :content,
    #     :clinic_review,
    #     :staff_quality,
    #     :doctor_quality,
    #     :impression_of_price,
    #     :impression_of_technology,
    #     :comfort_of_space,
    #     :status,
    #     s_selection_method_ids: [],
    #     inspection_ids: [],
    #     f_infertility_factor_ids: [],
    #     m_infertility_factor_ids: [],
    #     f_disease_ids: [],
    #     m_disease_ids: [],
    #     f_surgery_ids: [],
    #     m_surgery_ids: [],
    #     sairan_medicine_ids: [],
    #     transfer_medicine_ids: [],
    #     transfer_option_ids: [],
    #     other_effort_ids: [],
    #     supplement_ids: [],
    #     scope_of_disclosure_ids: [],
    #     tag_ids: [],
    #     day_of_sairans_attributes: [:id, :day, :e2, :fsh, :lh, :p4, :endometrial_thickness, :_destroy],
    #     day_of_shokihaiishokus_attributes: [:id, :et, :e2, :fsh, :lh, :p4, :_destroy],
    #     day_of_haibanhoishokus_attributes: [:id, :bt, :e2, :fsh, :lh, :p4, :_destroy],
    #     sairan_hormones_attributes: [:id, :day, :e2, :fsh, :lh, :p4, :_destroy],
    #     before_ishoku_hormones_attributes: [:id, :day, :e2, :fsh, :lh, :p4, :_destroy],
    #     shokihaiishoku_hormones_attributes: [:id, :et, :e2, :fsh, :lh, :p4, :hcg, :_destroy],
    #     haibanhoishoku_hormones_attributes: [:id, :bt, :e2, :fsh, :lh, :p4, :hcg, :_destroy],
    #     itinerary_of_choosing_a_clinics_attributes: [:id, :order_of_transfer, :clinic_id, :_destroy],
    #     special_inspections_attributes: [:id, :name, :place, :cost, :timing, :explanation, :_destroy],
    #   )
    # end

    def report_params
      params.require(:report).permit(
        :current_state,
        :clinic_id,
        :prefecture_id,
        :prefecture_at_the_time_status,
        :city_id,
        :city_at_the_time_status,
        :number_of_clinics,
        :clinic_selection_criteria,
        :briefing_session,
        :reasons_for_choosing_this_clinic,
        :year_of_treatment_end,
        :fertility_treatment_number,
        :types_of_fertilization_methods,
        :details_of_icsi,
        :transplant_method,
        :treatment_start_age,
        :first_age_to_start,
        :treatment_end_age,
        :age_of_partner_at_end_of_treatment,
        :treatment_period,
        :number_of_aih,
        :inspection_supplementary_explanation,
        :amh,
        :bmi,
        :smoking,
        :types_of_eggs_and_sperm,
        :description_of_eggs_and_sperm_used,
        :type_of_ovarian_stimulation,
        :type_of_sairan_cycle,
        :notes_on_type_of_sairan_cycle,
        :use_of_anesthesia,
        :selection_of_anesthesia_type,
        :total_number_of_sairan,
        :all_number_of_sairan,
        :number_of_eggs_collected,
        :number_of_fertilized_eggs,
        :number_of_transferable_embryos,
        :number_of_frozen_eggs,
        :egg_maturity,
        :ova_with_ivm,
        :embryo_culture_days,
        :embryo_stage,
        :early_embryo_grade,
        :early_embryo_grade_supplementary_explanation,
        :blastocyst_grade1,
        :blastocyst_grade1_supplementary_explanation,
        :blastocyst_grade2,
        :blastocyst_grade2_supplementary_explanation,
        :explanation_and_impression_about_sairan,
        :about_causes_of_infertility,
        :semen_volume,
        :semen_concentration,
        :sperm_advance_rate,
        :sperm_motility,
        :probability_of_normal_morphology_of_sperm,
        :total_amount_of_sperm,
        :sperm_description,
        :number_of_miscarriages,
        :number_of_stillbirths,
        :fuiku,
        :fuiku_supplementary_explanation,
        :pgt1,
        :pgt1_status,
        :pgt2,
        :pgt2_status,
        :pgt_supplementary_explanation,
        :pgt_supplementary_explanation_status,
        :total_number_of_transplants,
        :total_number_of_eggs_transplanted,
        :all_number_of_transplants,
        :number_of_eggs_stored,
        :frozen_embryo_storage_cost,
        :explanation_of_frozen_embryo_storage_cost,
        :explanation_and_impression_about_ishoku,
        :adoption,
        :other_effort_cost,
        :other_effort_supplementary_explanation,
        :supplement_cost,
        :supplement_supplementary_explanation,
        :sairan_cost,
        :sairan_cost_explanation,
        :ishoku_cost,
        :ishoku_cost_explanation,
        :cost,
        :explanation_of_cost,
        :all_cost,
        :number_of_times_the_grant_was_received,
        :all_grant_amount,
        :supplementary_explanation_of_grant,
        :credit_card_validity,
        :creditcards_can_be_used_from_more_than,
        :average_waiting_time,
        :reservation_method,
        :online_consultation,
        :online_consultation_details,
        :period_of_time_spent_traveling,
        :work_style,
        :work_style_status,
        :industry_type,
        :industry_type_status,
        :private_or_listed_company,
        :private_or_listed_company_status,
        :domestic_or_foreign_capital,
        :domestic_or_foreign_capital_status,
        :capital_size,
        :capital_size_status,
        :department,
        :department_status,
        :position,
        :position_status,
        :number_of_employees,
        :number_of_employees_status,
        :treatment_support_system,
        :suspended_or_retirement_job,
        :annual_income,
        :annual_income_status,
        :household_net_income,
        :household_net_income_status,
        :about_work_and_working_style,
        :title,
        :content,
        :clinic_review,
        :staff_quality,
        :doctor_quality,
        :impression_of_price,
        :impression_of_technology,
        :comfort_of_space,
        :status,
        s_selection_method_ids: [],
        inspection_ids: [],
        f_infertility_factor_ids: [],
        m_infertility_factor_ids: [],
        f_disease_ids: [],
        m_disease_ids: [],
        f_surgery_ids: [],
        m_surgery_ids: [],
        sairan_medicine_ids: [],
        transfer_medicine_ids: [],
        transfer_option_ids: [],
        other_effort_ids: [],
        supplement_ids: [],
        scope_of_disclosure_ids: [],
        tag_ids: [],
        day_of_sairans_attributes: [:id, :day, :e2, :fsh, :lh, :p4, :_destroy],
        day_of_shokihaiishokus_attributes: [:id, :day, :e2, :fsh, :lh, :p4, :endometrial_thickness, :_destroy],
        day_of_haibanhoishokus_attributes: [:id, :day, :e2, :fsh, :lh, :p4, :endometrial_thickness, :_destroy],
        sairan_hormones_attributes: [:id, :day, :e2, :fsh, :lh, :p4, :_destroy],
        before_ishoku_hormones_attributes: [:id, :day, :e2, :fsh, :lh, :p4, :_destroy],
        shokihaiishoku_hormones_attributes: [:id, :et, :e2, :fsh, :lh, :p4, :hcg, :_destroy],
        haibanhoishoku_hormones_attributes: [:id, :bt, :e2, :fsh, :lh, :p4, :hcg, :_destroy],
        itinerary_of_choosing_a_clinics_attributes: [:id, :order_of_transfer, :clinic_id, :_destroy],
        special_inspections_attributes: [:id, :name, :place, :cost, :timing, :explanation, :_destroy],
      )
    end
end