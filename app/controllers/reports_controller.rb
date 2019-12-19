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
    # toptags = ReportTag.group(:tag_id).order("count_all desc").count.first
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
    @report.current_state = session[:current_state]
    @report.clinic_id = session[:clinic_id]
    @report.number_of_clinics = session[:number_of_clinics]
    @report.clinic_selection_criteria = session[:clinic_selection_criteria]
    @report.reasons_for_choosing_this_clinic = session[:reasons_for_choosing_this_clinic]
    @report.title = session[:title]
    # @report.content = session[:content]
    @report.fertility_treatment_number = session[:fertility_treatment_number]
    @report.treatment_type = session[:treatment_type]
    @report.treatment_start_age = session[:treatment_start_age]
    @report.treatment_end_age = session[:treatment_end_age]
    @report.treatment_period = session[:treatment_period]
    @report.number_of_aih = session[:number_of_aih]
    @report.amh = session[:amh]
    @report.bmi = session[:bmi]
    @report.smoking = session[:smoking]
    @report.f_infertility_factor_ids = session[:f_infertility_factor_ids]
    # @report.fif_name = session[:fif_name]
    @report.m_infertility_factor_ids = session[:m_infertility_factor_ids]
    # @report.mif_name = session[:mif_name]
    @report.f_disease_ids = session[:f_disease_ids]
    # @report.fd_name = session[:fd_name]
    @report.m_disease_ids = session[:m_disease_ids]
    # @report.md_name = session[:md_name]
    @report.f_surgery_ids = session[:f_surgery_ids]
    # @report.fs_name = session[:fs_name]
    @report.m_surgery_ids = session[:m_surgery_ids]
    # @report.ms_name = session[:ms_name]
    @report.types_of_eggs_and_sperm = session[:types_of_eggs_and_sperm]
    @report.type_of_sairan_cycle = session[:type_of_sairan_cycle]
    @report.sairan_medicine_ids = session[:sairan_medicine_ids]
    # # @report.sm_name = session[:sm_name]
    @report.total_number_of_sairan = session[:total_number_of_sairan]
    @report.all_number_of_sairan = session[:all_number_of_sairan]
    @report.number_of_eggs_collected = session[:number_of_eggs_collected]
    @report.egg_maturity = session[:egg_maturity]
    @report.ova_with_ivm = session[:ova_with_ivm]
    @report.types_of_fertilization_methods = session[:types_of_fertilization_methods]
    @report.number_of_fertilized_eggs = session[:number_of_fertilized_eggs]
    @report.number_of_frozen_eggs = session[:number_of_frozen_eggs]
    @report.embryo_culture_days = session[:embryo_culture_days]
    @report.embryo_stage = session[:embryo_stage]
    @report.early_embryo_grade = session[:early_embryo_grade]
    @report.blastocyst_grade1 = session[:blastocyst_grade1]
    @report.blastocyst_grade2 = session[:blastocyst_grade2]
    @report.transfer_medicine_ids = session[:transfer_medicine_ids]
    # @report.tm_name = session[:tm_name]
    @report.transfer_option_ids = session[:transfer_option_ids]
    # @report.to_name = session[:to_name]
    @report.total_number_of_transplants = session[:total_number_of_transplants]
    @report.all_number_of_transplants = session[:all_number_of_transplants]
    @report.number_of_eggs_stored = session[:number_of_eggs_stored]
    @report.other_effort_ids = session[:other_effort_ids]
    # @report.oe_name = session[:oe_name]
    @report.supplement_ids = session[:supplement_ids]
    # @report.supplement_name = session[:supplement_name]
    @report.cost = session[:cost]
    @report.credit_card_validity = session[:credit_card_validity]
    @report.average_waiting_time = session[:average_waiting_time]
    @report.period_of_time_spent_traveling = session[:period_of_time_spent_traveling]
    @report.work_style = session[:work_style]
    @report.private_or_listed_company = session[:private_or_listed_company]
    @report.capital_size = session[:capital_size]
    @report.position = session[:position]
    @report.treatment_support_system = session[:treatment_support_system]
    @report.industry_type = session[:industry_type]
    @report.domestic_or_foreign_capital = session[:domestic_or_foreign_capital]
    @report.department = session[:department]
    @report.number_of_employees = session[:number_of_employees]
    @report.suspended_or_retirement_job = session[:suspended_or_retirement_job]
    @report.scope_of_disclosure_ids = session[:scope_of_disclosure_ids]
    # @report.sod_scope = session[:sod_scope]
    @report.tag_ids = session[:tag_ids]
    # @report.tag_name = session[:tag_name]

    @all_tag_list = Tag.all.pluck(:tag_name)
  end

  def confirm
    @report = Report.new(report_params_for_confirm)
    session[:current_state] = params[:report][:current_state]
    session[:clinic_id] = params[:report][:clinic_id]
    session[:number_of_clinics] = params[:report][:number_of_clinics]
    session[:clinic_selection_criteria] = params[:report][:clinic_selection_criteria]
    session[:reasons_for_choosing_this_clinic] = params[:report][:reasons_for_choosing_this_clinic]
    session[:title] = params[:report][:title]
    # session[:content] = params[:report][:content]
    session[:fertility_treatment_number] = params[:report][:fertility_treatment_number]
    session[:treatment_type] = params[:report][:treatment_type]
    session[:treatment_start_age] = params[:report][:treatment_start_age]
    session[:treatment_end_age] = params[:report][:treatment_end_age]
    session[:treatment_period] = params[:report][:treatment_period]
    session[:number_of_aih] = params[:report][:number_of_aih]
    session[:amh] = params[:report][:amh]
    session[:bmi] = params[:report][:bmi]
    session[:smoking] = params[:report][:smoking]
    session[:f_infertility_factor_ids] = params[:report][:f_infertility_factor_ids]
    session[:fif_name] = params[:report][:fif_name]
    session[:m_infertility_factor_ids] = params[:report][:m_infertility_factor_ids]
    session[:mif_name] = params[:report][:mif_name]
    session[:f_disease_ids] = params[:report][:f_disease_ids]
    session[:fd_name] = params[:report][:fd_name]
    session[:m_disease_ids] = params[:report][:m_disease_ids]
    session[:md_name] = params[:report][:md_name]
    session[:f_surgery_ids] = params[:report][:f_surgery_ids]
    session[:fs_name] = params[:report][:fs_name]
    session[:m_surgery_ids] = params[:report][:m_surgery_ids]
    session[:ms_name] = params[:report][:ms_name]
    session[:types_of_eggs_and_sperm] = params[:report][:types_of_eggs_and_sperm]
    session[:type_of_sairan_cycle] = params[:report][:type_of_sairan_cycle]
    session[:sairan_medicine_ids] = params[:report][:sairan_medicine_ids]
    session[:sm_name] = params[:report][:sm_name]
    session[:total_number_of_sairan] = params[:report][:total_number_of_sairan]
    session[:all_number_of_sairan] = params[:report][:all_number_of_sairan]
    session[:number_of_eggs_collected] = params[:report][:number_of_eggs_collected]
    session[:egg_maturity] = params[:report][:egg_maturity]
    session[:ova_with_ivm] = params[:report][:ova_with_ivm]
    session[:types_of_fertilization_methods] = params[:report][:types_of_fertilization_methods]
    session[:number_of_fertilized_eggs] = params[:report][:number_of_fertilized_eggs]
    session[:number_of_frozen_eggs] = params[:report][:number_of_frozen_eggs]
    session[:embryo_culture_days] = params[:report][:embryo_culture_days]
    session[:embryo_stage] = params[:report][:embryo_stage]
    session[:early_embryo_grade] = params[:report][:early_embryo_grade]
    session[:blastocyst_grade1] = params[:report][:blastocyst_grade1]
    session[:blastocyst_grade2] = params[:report][:blastocyst_grade2]
    session[:transfer_medicine_ids] = params[:report][:transfer_medicine_ids]
    session[:tm_name] = params[:report][:tm_name]
    session[:transfer_option_ids] = params[:report][:transfer_option_ids]
    session[:to_name] = params[:report][:to_name]
    session[:total_number_of_transplants] = params[:report][:total_number_of_transplants]
    session[:all_number_of_transplants] = params[:report][:all_number_of_transplants]
    session[:number_of_eggs_stored] = params[:report][:number_of_eggs_stored]
    session[:other_effort_ids] = params[:report][:other_effort_ids]
    session[:oe_name] = params[:report][:oe_name]
    session[:supplement_ids] = params[:report][:supplement_ids]
    session[:supplement_name] = params[:report][:supplement_name]
    session[:cost] = params[:report][:cost]
    session[:credit_card_validity] = params[:report][:credit_card_validity]
    session[:average_waiting_time] = params[:report][:average_waiting_time]
    session[:period_of_time_spent_traveling] = params[:report][:period_of_time_spent_traveling]
    session[:work_style] = params[:report][:work_style]
    session[:private_or_listed_company] = params[:report][:private_or_listed_company]
    session[:capital_size] = params[:report][:capital_size]
    session[:position] = params[:report][:position]
    session[:treatment_support_system] = params[:report][:treatment_support_system]
    session[:industry_type] = params[:report][:industry_type]
    session[:domestic_or_foreign_capital] = params[:report][:domestic_or_foreign_capital]
    session[:department] = params[:report][:department]
    session[:number_of_employees] = params[:report][:number_of_employees]
    session[:suspended_or_retirement_job] = params[:report][:suspended_or_retirement_job]
    session[:scope_of_disclosure_ids] = params[:report][:scope_of_disclosure_ids]
    session[:sod_scope] = params[:report][:sod_scope]
    session[:tag_ids] = params[:report][:tag_ids]
    session[:tag_name] = params[:report][:tag_name]

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
        :credit_card_validity,
        :average_waiting_time,
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
        :credit_card_validity,
        :average_waiting_time,
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
        :suspended_or_retirement_job,
        :reasons_for_choosing_this_clinic,
        :content,
        :clinic_review,
        :status,
      )
    end
end
