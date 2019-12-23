class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]

  def home
    set_allreport
    @reports = Report.all
    @users = User.all
  end

  def index
    set_allreport
    @reports = Report.published.order("created_at DESC").page(params[:page]).per(10)
    # toptags = ReportTag.group(:tag_id).order("created_at DESC").take(3)
    # @toptags = Tag.find(toptags)
  end

  def draft
    @user = current_user
    @reports = @user.reports.draft.order("created_at DESC").page(params[:page]).per(10)
  end

  def show
    @f_infertility_factors = @report.f_infertility_factors
    @m_infertility_factors = @report.m_infertility_factors
    @f_diseases = @report.f_diseases
    @m_diseases = @report.m_diseases
    @f_surgeries = @report.f_surgeries
    @m_surgeries = @report.m_surgeries
    @sairan_medicines = @report.sairan_medicines
    @transfer_medicines = @report.transfer_medicines
    @transfer_options = @report.transfer_options
    @other_efforts = @report.other_efforts
    @supplements = @report.supplements
    @scope_of_disclosures = @report.scope_of_disclosures
    @comment = Comment.new(report_id: @report.id)

    if @report.draft? && @report.user != current_user
      redirect_to root_path
    end
  end

  def new
    @report = Report.new
    @all_tag_list = Tag.all.pluck(:tag_name)
  end

  def confirm
    @report = Report.new(report_params_for_confirm)

    if params[:temp].nil?
      @report.status = params[:status2]
    else
      @report.status = params[:status1]
    end

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

  def create
    @report = Report.new(report_params_for_create)
    @report.user_id = current_user.id

    fif_list = params[:fif_name].split(",")
    fif_ids = params[:report][:f_infertility_factor_ids]
    fif_ids.each do |fif_id|
      if fif_id.blank?
        next
      end
      fif = FInfertilityFactor.find(fif_id)
      fif_list << fif.name
    end
    fif_list = fif_list.uniq

    mif_list = params[:mif_name].split(",")
    mif_ids = params[:report][:m_infertility_factor_ids]
    mif_ids.each do |mif_id|
      if mif_id.blank?
        next
      end
      mif = MInfertilityFactor.find(mif_id)
      mif_list << mif.name
    end
    mif_list = mif_list.uniq

    fd_list = params[:fd_name].split(",")
    fd_ids = params[:report][:f_disease_ids]
    fd_ids.each do |fd_id|
      if fd_id.blank?
        next
      end
      fd = FDisease.find(fd_id)
      fd_list << fd.name
    end
    fd_list = fd_list.uniq

    md_list = params[:md_name].split(",")
    md_ids = params[:report][:m_disease_ids]
    md_ids.each do |md_id|
      if md_id.blank?
        next
      end
      md = MDisease.find(md_id)
      md_list << md.name
    end
    md_list = md_list.uniq

    fs_list = params[:fs_name].split(",")
    fs_ids = params[:report][:f_surgery_ids]
    fs_ids.each do |fs_id|
      if fs_id.blank?
        next
      end
      fs = FSurgery.find(fs_id)
      fs_list << fs.name
    end
    fs_list = fs_list.uniq

    ms_list = params[:ms_name].split(",")
    ms_ids = params[:report][:m_surgery_ids]
    ms_ids.each do |ms_id|
      if ms_id.blank?
        next
      end
      ms = MSurgery.find(ms_id)
      ms_list << ms.name
    end
    ms_list = ms_list.uniq

    sm_list = params[:sm_name].split(",")
    sm_ids = params[:report][:sairan_medicine_ids]
    sm_ids.each do |sm_id|
      if sm_id.blank?
        next
      end
      sm = SairanMedicine.find(sm_id)
      sm_list << sm.name
    end
    sm_list = sm_list.uniq

    tm_list = params[:tm_name].split(",")
    tm_ids = params[:report][:transfer_medicine_ids]
    tm_ids.each do |tm_id|
      if tm_id.blank?
        next
      end
      tm = TransferMedicine.find(tm_id)
      tm_list << tm.name
    end
    tm_list = tm_list.uniq

    to_list = params[:to_name].split(",")
    to_ids = params[:report][:transfer_option_ids]
    to_ids.each do |to_id|
      if to_id.blank?
        next
      end
      to = TransferOption.find(to_id)
      to_list << to.name
    end
    to_list = to_list.uniq

    oe_list = params[:oe_name].split(",")
    oe_ids = params[:report][:other_effort_ids]
    oe_ids.each do |oe_id|
      if oe_id.blank?
        next
      end
      oe = OtherEffort.find(oe_id)
      oe_list << oe.name
    end
    to_list = to_list.uniq

    supplement_list = params[:supplement_name].split(",")
    supplement_ids = params[:report][:supplement_ids]
    supplement_ids.each do |supplement_id|
      if supplement_id.blank?
        next
      end
      supplement = Supplement.find(supplement_id)
      supplement_list << supplement.name
    end
    supplement_list = supplement_list.uniq

    sod_list = params[:sod_scope].split(",")
    sod_ids = params[:report][:scope_of_disclosure_ids]
    sod_ids.each do |sod_id|
      if sod_id.blank?
        next
      end
      sod = ScopeOfDisclosure.find(sod_id)
      sod_list << sod.scope
    end
    sod_list = sod_list.uniq

    tag_list = params[:tag_name].split(",")
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
        binding.pry
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @tag_list = @report.tags.pluck(:tag_name).join(",")
  end

  def update
    tag_list = params[:report][:tag_name].split(",")
    respond_to do |format|
      if @report.update(report_params)
        @report.save_reports(tag_list)
        format.html { redirect_to @report, notice: 'レポートを更新しました。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'レポートを削除しました。' }
    end
  end

  private
  
    def set_report
      @report = Report.find(params[:id])
    end

    def set_allreport
      @reports = params[:tag_id].present? ? Tag.find(params[:tag_id]).reports : Report.all
      @reports = @reports.page(params[:page]).order(updated_at: :desc)
    end

    def report_params_for_confirm
      params.require(:report).permit(
        :clinic_id,
        :title,
        :current_state,
        :fertility_treatment_number,
        :number_of_clinics,
        :clinic_selection_criteria,
        :treatment_type,
        :treatment_start_age,
        :treatment_end_age,
        :treatment_period,
        :number_of_aih,
        :amh,
        :bmi,
        :smoking,
        :types_of_eggs_and_sperm,
        :type_of_sairan_cycle,
        :total_number_of_sairan,
        :all_number_of_sairan,
        :number_of_eggs_collected,
        :egg_maturity,
        :ova_with_ivm,
        :types_of_fertilization_methods,
        :number_of_fertilized_eggs,
        :number_of_frozen_eggs,
        :embryo_culture_days,
        :embryo_stage,
        :early_embryo_grade,
        :blastocyst_grade1,
        :blastocyst_grade2,
        :total_number_of_transplants,
        :all_number_of_transplants,
        :number_of_eggs_stored,
        :cost,
        :all_cost,
        :credit_card_validity,
        :average_waiting_time,
        :reservation_method,
        :period_of_time_spent_traveling,
        :address_at_that_time,
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
        :suspended_or_retirement_job,
        :reasons_for_choosing_this_clinic,
        :content,
        :clinic_review,
        :status,
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
        :fertility_treatment_number,
        :number_of_clinics,
        :clinic_selection_criteria,
        :treatment_type,
        :treatment_start_age,
        :treatment_end_age,
        :treatment_period,
        :number_of_aih,
        :amh,
        :bmi,
        :smoking,
        :types_of_eggs_and_sperm,
        :type_of_sairan_cycle,
        :total_number_of_sairan,
        :all_number_of_sairan,
        :number_of_eggs_collected,
        :egg_maturity,
        :ova_with_ivm,
        :types_of_fertilization_methods,
        :number_of_fertilized_eggs,
        :number_of_frozen_eggs,
        :embryo_culture_days,
        :embryo_stage,
        :early_embryo_grade,
        :blastocyst_grade1,
        :blastocyst_grade2,
        :total_number_of_transplants,
        :all_number_of_transplants,
        :number_of_eggs_stored,
        :cost,
        :all_cost,
        :credit_card_validity,
        :average_waiting_time,
        :reservation_method,
        :period_of_time_spent_traveling,
        :address_at_that_time,
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
        :suspended_or_retirement_job,
        :household_net_income,
        :reasons_for_choosing_this_clinic,
        :content,
        :clinic_review,
        :status,
      )
    end
end
