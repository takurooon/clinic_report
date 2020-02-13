class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]

  def home
  end

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
  end

  def new
    @report = Report.new
    @all_tag_list = Tag.all.pluck(:tag_name)
  end

  def confirm
    flash[:alert] = "まだ投稿は完了していません。必須項目の「クリニック」と「お住まい(非公開設定可)」は選択済みですか？"
    if params[:id].blank?
      @report = Report.new(report_params_for_confirm)
    else
      @report = Report.find(params[:id])
      @report.attributes = report_params_for_confirm
    end

    if params[:temp].blank?
      @report.status = params[:status2]
    else
      @report.status = params[:status1]
    end

    if @report.status.blank?
      @report.status = "released"
    end

    @i_name = params[:i_name]
    @fif_name = params[:fif_name]
    @mif_name = params[:mif_name]
    @fd_name = params[:fd_name]
    @md_name = params[:md_name]
    @fs_name = params[:fs_name]
    @ms_name = params[:ms_name] 
    @sm_name = params[:sm_name] 
    @tm_name = params[:tm_name]
    @to_name = params[:to_name]
    @oe_name = params[:oe_name]
    @supplement_name = params[:supplement_name]
    @sod_scope = params[:sod_scope]
    @tag_name = params[:tag_name]
  end

  def molding(materials)
    list = materials.map do |material|
      material.gsub(/(\s|　)+/, '')
    end
  end

  def create
    @report = Report.new(report_params_for_create)
    @report.user_id = current_user.id

    @report.normalize

    if @report.status.blank?
      @report.status = "released"
    end

    i_name = params[:i_name].split(",")
    i_list = molding(i_name)
    i_ids = params[:report][:inspection_ids]
    i_ids.each do |i_id|
      if i_id.blank?
        next
      end
      i = Inspection.find(i_id)
      i_list << i.name
    end
    i_list = i_list.uniq

    fif_name = params[:fif_name].split(",")
    fif_list = molding(fif_name)
    fif_ids = params[:report][:f_infertility_factor_ids]
    fif_ids.each do |fif_id|
      if fif_id.blank?
        next
      end
      fif = FInfertilityFactor.find(fif_id)
      fif_list << fif.name
    end
    fif_list = fif_list.uniq

    mif_name = params[:mif_name].split(",")
    mif_list = molding(mif_name)
    mif_ids = params[:report][:m_infertility_factor_ids]
    mif_ids.each do |mif_id|
      if mif_id.blank?
        next
      end
      mif = MInfertilityFactor.find(mif_id)
      mif_list << mif.name
    end
    mif_list = mif_list.uniq

    fd_name = params[:fd_name].split(",")
    fd_list = molding(fd_name)
    fd_ids = params[:report][:f_disease_ids]
    fd_ids.each do |fd_id|
      if fd_id.blank?
        next
      end
      fd = FDisease.find(fd_id)
      fd_list << fd.name
    end
    fd_list = fd_list.uniq

    md_name = params[:md_name].split(",")
    md_list = molding(md_name)
    md_ids = params[:report][:m_disease_ids]
    md_ids.each do |md_id|
      if md_id.blank?
        next
      end
      md = MDisease.find(md_id)
      md_list << md.name
    end
    md_list = md_list.uniq

    fs_name = params[:fs_name].split(",")
    fs_list = molding(fs_name)
    fs_ids = params[:report][:f_surgery_ids]
    fs_ids.each do |fs_id|
      if fs_id.blank?
        next
      end
      fs = FSurgery.find(fs_id)
      fs_list << fs.name
    end
    fs_list = fs_list.uniq

    ms_name = params[:ms_name].split(",")
    ms_list = molding(ms_name)
    ms_ids = params[:report][:m_surgery_ids]
    ms_ids.each do |ms_id|
      if ms_id.blank?
        next
      end
      ms = MSurgery.find(ms_id)
      ms_list << ms.name
    end
    ms_list = ms_list.uniq

    sm_name = params[:sm_name].split(",")
    sm_list = molding(sm_name)
    sm_ids = params[:report][:sairan_medicine_ids]
    sm_ids.each do |sm_id|
      if sm_id.blank?
        next
      end
      sm = SairanMedicine.find(sm_id)
      sm_list << sm.name
    end
    sm_list = sm_list.uniq

    tm_name = params[:tm_name].split(",")
    tm_list = molding(tm_name)
    tm_ids = params[:report][:transfer_medicine_ids]
    tm_ids.each do |tm_id|
      if tm_id.blank?
        next
      end
      tm = TransferMedicine.find(tm_id)
      tm_list << tm.name
    end
    tm_list = tm_list.uniq

    to_name = params[:to_name].split(",")
    to_list = molding(to_name)
    to_ids = params[:report][:transfer_option_ids]
    to_ids.each do |to_id|
      if to_id.blank?
        next
      end
      to = TransferOption.find(to_id)
      to_list << to.name
    end
    to_list = to_list.uniq

    oe_name = params[:oe_name].split(",")
    oe_list = molding(oe_name)
    oe_ids = params[:report][:other_effort_ids]
    oe_ids.each do |oe_id|
      if oe_id.blank?
        next
      end
      oe = OtherEffort.find(oe_id)
      oe_list << oe.name
    end
    to_list = to_list.uniq

    supplement_name = params[:supplement_name].split(",")
    supplement_list = molding(supplement_name)
    supplement_ids = params[:report][:supplement_ids]
    supplement_ids.each do |supplement_id|
      if supplement_id.blank?
        next
      end
      supplement = Supplement.find(supplement_id)
      supplement_list << supplement.name
    end
    supplement_list = supplement_list.uniq

    sod_name = params[:sod_scope].split(",")
    sod_list = molding(sod_name)
    sod_ids = params[:report][:scope_of_disclosure_ids]
    sod_ids.each do |sod_id|
      if sod_id.blank?
        next
      end
      sod = ScopeOfDisclosure.find(sod_id)
      sod_list << sod.scope
    end
    sod_list = sod_list.uniq

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
        @report.save_i(i_list)
        @report.save_fifs(fif_list)
        @report.save_mifs(mif_list)
        @report.save_fds(fd_list)
        @report.save_mds(md_list)
        @report.save_fss(fs_list)
        @report.save_mss(ms_list)
        @report.save_sms(sm_list)
        @report.save_tms(tm_list)
        @report.save_tos(to_list)
        @report.save_oes(oe_list)
        @report.save_supplements(supplement_list)
        @report.save_sods(sod_list)
        @report.save_tags(tag_list)
        format.html { redirect_to report_path(@report), notice: 'レポートを作成しました。' }
        format.json { render :show, status: :created, location: @report }
      else
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
  end

  def release
    report =  Report.find(params[:id])
    report.released! unless report.released?
    redirect_to edit_report_path(report), notice: 'このレポートを公開しました'
  end

  def nonrelease
    report =  Report.find(params[:id])
    report.nonreleased! unless report.nonreleased?
    redirect_to edit_report_path(report), notice: 'このレポートを非公開にしました'
  end

  def update
    if @report.user != current_user
      redirect_to root_path, alert: '編集権限がありません' 
      return
    end
    @report = Report.find(params[:id])

    i_name = params[:i_name].split(",")
    i_list = molding(i_name)
    i_ids = params[:report][:inspection_ids]
    i_ids.each do |i_id|
      if i_id.blank?
        next
      end
      i = Inspection.find(i_id)
      i_list << i.name
    end
    i_list = i_list.uniq

    fif_name = params[:fif_name].split(",")
    fif_list = molding(fif_name)
    fif_ids = params[:report][:f_infertility_factor_ids]
    fif_ids.each do |fif_id|
      if fif_id.blank?
        next
      end
      fif = FInfertilityFactor.find(fif_id)
      fif_list << fif.name
    end
    fif_list = fif_list.uniq

    mif_name = params[:mif_name].split(",")
    mif_list = molding(mif_name)
    mif_ids = params[:report][:m_infertility_factor_ids]
    mif_ids.each do |mif_id|
      if mif_id.blank?
        next
      end
      mif = MInfertilityFactor.find(mif_id)
      mif_list << mif.name
    end
    mif_list = mif_list.uniq

    fd_name = params[:fd_name].split(",")
    fd_list = molding(fd_name)
    fd_ids = params[:report][:f_disease_ids]
    fd_ids.each do |fd_id|
      if fd_id.blank?
        next
      end
      fd = FDisease.find(fd_id)
      fd_list << fd.name
    end
    fd_list = fd_list.uniq

    md_name = params[:md_name].split(",")
    md_list = molding(md_name)
    md_ids = params[:report][:m_disease_ids]
    md_ids.each do |md_id|
      if md_id.blank?
        next
      end
      md = MDisease.find(md_id)
      md_list << md.name
    end
    md_list = md_list.uniq

    fs_name = params[:fs_name].split(",")
    fs_list = molding(fs_name)
    fs_ids = params[:report][:f_surgery_ids]
    fs_ids.each do |fs_id|
      if fs_id.blank?
        next
      end
      fs = FSurgery.find(fs_id)
      fs_list << fs.name
    end
    fs_list = fs_list.uniq

    ms_name = params[:ms_name].split(",")
    ms_list = molding(ms_name)
    ms_ids = params[:report][:m_surgery_ids]
    ms_ids.each do |ms_id|
      if ms_id.blank?
        next
      end
      ms = MSurgery.find(ms_id)
      ms_list << ms.name
    end
    ms_list = ms_list.uniq

    sm_name = params[:sm_name].split(",")
    sm_list = molding(sm_name)
    sm_ids = params[:report][:sairan_medicine_ids]
    sm_ids.each do |sm_id|
      if sm_id.blank?
        next
      end
      sm = SairanMedicine.find(sm_id)
      sm_list << sm.name
    end
    sm_list = sm_list.uniq

    tm_name = params[:tm_name].split(",")
    tm_list = molding(tm_name)
    tm_ids = params[:report][:transfer_medicine_ids]
    tm_ids.each do |tm_id|
      if tm_id.blank?
        next
      end
      tm = TransferMedicine.find(tm_id)
      tm_list << tm.name
    end
    tm_list = tm_list.uniq

    to_name = params[:to_name].split(",")
    to_list = molding(to_name)
    to_ids = params[:report][:transfer_option_ids]
    to_ids.each do |to_id|
      if to_id.blank?
        next
      end
      to = TransferOption.find(to_id)
      to_list << to.name
    end
    to_list = to_list.uniq

    oe_name = params[:oe_name].split(",")
    oe_list = molding(oe_name)
    oe_ids = params[:report][:other_effort_ids]
    oe_ids.each do |oe_id|
      if oe_id.blank?
        next
      end
      oe = OtherEffort.find(oe_id)
      oe_list << oe.name
    end
    to_list = to_list.uniq

    supplement_name = params[:supplement_name].split(",")
    supplement_list = molding(supplement_name)
    supplement_ids = params[:report][:supplement_ids]
    supplement_ids.each do |supplement_id|
      if supplement_id.blank?
        next
      end
      supplement = Supplement.find(supplement_id)
      supplement_list << supplement.name
    end
    supplement_list = supplement_list.uniq

    sod_name = params[:sod_scope].split(",")
    sod_list = molding(sod_name)
    sod_ids = params[:report][:scope_of_disclosure_ids]
    sod_ids.each do |sod_id|
      if sod_id.blank?
        next
      end
      sod = ScopeOfDisclosure.find(sod_id)
      sod_list << sod.scope
    end
    sod_list = sod_list.uniq

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
        format.html { render :edit }
      elsif @report.update(report_params_for_create)
        @report.save_i(i_list)
        @report.save_fifs(fif_list)
        @report.save_mifs(mif_list)
        @report.save_fds(fd_list)
        @report.save_mds(md_list)
        @report.save_fss(fs_list)
        @report.save_mss(ms_list)
        @report.save_sms(sm_list)
        @report.save_tms(tm_list)
        @report.save_tos(to_list)
        @report.save_oes(oe_list)
        @report.save_supplements(supplement_list)
        @report.save_sods(sod_list)
        @report.save_tags(tag_list)
        format.html { redirect_to report_path(@report), notice: 'レポートを作成しました。' }
        format.json { render :show, status: :created, location: @report }
      else
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
      format.html { redirect_to reports_url, notice: 'レポートを削除しました。' }
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

    def report_params_for_confirm
      params.require(:report).permit(
        :clinic_id,
        :title,
        :current_state,
        :year_of_treatment_end,
        :fertility_treatment_number,
        :number_of_clinics,
        :clinic_selection_criteria,
        :treatment_type,
        :treatment_start_age,
        :first_age_to_start,
        :treatment_end_age,
        :treatment_period,
        :number_of_aih,
        :special_inspection_supplementary_explanation,
        :pgt,
        :amh,
        :bmi,
        :smoking,
        :types_of_eggs_and_sperm,
        :type_of_ovarian_stimulation,
        :type_of_sairan_cycle,
        :notes_on_type_of_sairan_cycle,
        :notes_on_type_of_sairan_cycle,
        :use_of_anesthesia,
        :selection_of_anesthesia_type,
        :total_number_of_sairan,
        :all_number_of_sairan,
        :number_of_eggs_collected,
        :egg_maturity,
        :ova_with_ivm,
        :types_of_fertilization_methods,
        :number_of_fertilized_eggs,
        :number_of_transferable_embryos,
        :number_of_frozen_eggs,
        :embryo_culture_days,
        :embryo_stage,
        :early_embryo_grade,
        :early_embryo_grade_supplementary_explanation,
        :blastocyst_grade1,
        :blastocyst_grade1_supplementary_explanation,
        :blastocyst_grade2,
        :blastocyst_grade2_supplementary_explanation,
        :total_number_of_transplants,
        :all_number_of_transplants,
        :number_of_eggs_stored,
        :frozen_embryo_storage_cost,
        :number_of_miscarriages,
        :number_of_stillbirths,
        :adoption,
        :supplement_supplementary_explanation,
        :cost,
        :all_cost,
        :credit_card_validity,
        :average_waiting_time,
        :reservation_method,
        :period_of_time_spent_traveling,
        :prefecture_id,
        :prefecture_at_the_time_status,
        :city_id,
        :city_at_the_time_status,
        :work_style,
        :industry_type,
        :private_or_listed_company,
        :domestic_or_foreign_capital,
        :capital_size,
        :department,
        :position,
        :number_of_employees,
        :treatment_support_system,
        :annual_income,
        :household_net_income,
        :suspended_or_retirement_job,
        :reasons_for_choosing_this_clinic,
        :content,
        :clinic_review,
        :status,
        :annual_income_status,
        :household_net_income_status,
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
        tag_ids: []
      )
    end

    def report_params_for_create
      params.require(:report).permit(
        :clinic_id,
        :title,
        :current_state,
        :year_of_treatment_end,
        :fertility_treatment_number,
        :number_of_clinics,
        :clinic_selection_criteria,
        :treatment_type,
        :treatment_start_age,
        :first_age_to_start,
        :treatment_end_age,
        :treatment_period,
        :number_of_aih,
        :special_inspection_supplementary_explanation,
        :pgt,
        :amh,
        :bmi,
        :smoking,
        :types_of_eggs_and_sperm,
        :type_of_ovarian_stimulation,
        :type_of_sairan_cycle,
        :notes_on_type_of_sairan_cycle,
        :notes_on_type_of_sairan_cycle,
        :use_of_anesthesia,
        :selection_of_anesthesia_type,
        :total_number_of_sairan,
        :all_number_of_sairan,
        :number_of_eggs_collected,
        :egg_maturity,
        :ova_with_ivm,
        :types_of_fertilization_methods,
        :number_of_fertilized_eggs,
        :number_of_transferable_embryos,
        :number_of_frozen_eggs,
        :embryo_culture_days,
        :embryo_stage,
        :early_embryo_grade,
        :early_embryo_grade_supplementary_explanation,
        :blastocyst_grade1,
        :blastocyst_grade1_supplementary_explanation,
        :blastocyst_grade2,
        :blastocyst_grade2_supplementary_explanation,
        :total_number_of_transplants,
        :all_number_of_transplants,
        :number_of_eggs_stored,
        :frozen_embryo_storage_cost,
        :number_of_miscarriages,
        :number_of_stillbirths,
        :adoption,
        :supplement_supplementary_explanation,
        :cost,
        :all_cost,
        :credit_card_validity,
        :average_waiting_time,
        :reservation_method,
        :period_of_time_spent_traveling,
        :prefecture_id,
        :prefecture_at_the_time_status,
        :city_id,
        :city_at_the_time_status,
        :work_style,
        :industry_type,
        :private_or_listed_company,
        :domestic_or_foreign_capital,
        :capital_size,
        :department,
        :position,
        :number_of_employees,
        :treatment_support_system,
        :annual_income,
        :household_net_income,
        :suspended_or_retirement_job,
        :reasons_for_choosing_this_clinic,
        :content,
        :clinic_review,
        :status,
        :annual_income_status,
        :household_net_income_status,
      )
    end
end
