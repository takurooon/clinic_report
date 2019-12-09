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
  end

  def show
    set_report
    @comment = Comment.new(report_id: @report.id)
  end

  def new
    @report = Report.new
  end

  def confirm
    @report = Report.new(report_params_for_confirm)
    @tag_name = params[:tag_name]
  end

  def create
    @report = Report.new(report_params_for_create)
    @report.user_id = current_user.id
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
        @report.save_reports(tag_list)
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
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'レポートを削除しました。' }
      format.json { head :no_content }
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
        f_infertility_factor_ids: [],
        m_infertility_factor_ids: [],
        f_disease_ids: [],
        m_disease_ids: [],
        f_surgery_ids: [],
        m_surgery_ids: [],
        ovarian_stimulation_ids: [],
        ovulation_inhibitor_ids: [],
        ovulation_inducer_ids: [],
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
        f_infertility_factor_ids: [],
        m_infertility_factor_ids: [],
        f_disease_ids: [],
        m_disease_ids: [],
        f_surgery_ids: [],
        m_surgery_ids: [],
        ovarian_stimulation_ids: [],
        ovulation_inhibitor_ids: [],
        ovulation_inducer_ids: [],
        transfer_option_ids: [],
        other_effort_ids: [],
        supplement_ids: [],
        scope_of_disclosure_ids: []
      )
    end
end
