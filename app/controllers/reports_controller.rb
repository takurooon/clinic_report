class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]

  def home
    @reports = params[:tag_id].present? ? Tag.find(params[:tag_id]).reports : Report.all
    @reports = @reports.page(params[:page]).order(updated_at: :desc)
    @reports = Report.all
    @users = User.all
  end

  def index
    @reports = params[:tag_id].present? ? Tag.find(params[:tag_id]).reports : Report.all
    @reports = @reports.page(params[:page]).order(updated_at: :desc)
  end

  def show
    @comment = Comment.new(report_id: @report.id)
  end

  def new
    @report = Report.new
  end

  def edit
  end

  def create
    @report = Report.new(report_params)
    @report.user_id = current_user.id
  
    respond_to do |format|
      if @report.save
        format.html { redirect_to report_path(@report), notice: 'レポートを作成しました。' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @report.update(report_params)
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

    def report_params
      params.require(:report).permit(
      :title,
      :fertility_treatment_number,
      :treatment_type,
      :current_state,
      :work_style,
      :number_of_employees,
      :address_at_that_time,
      :number_of_clinics,
      :address_at_that_time,
      :number_of_aih,
      :treatment_start_age,
      :treatment_end_age,
      :treatment_period,
      :amh,
      :bmi,
      :types_of_eggs_and_sperm,
      :total_number_of_sairan,
      :number_of_eggs_collected,
      :total_number_of_transplants,
      :number_of_eggs_stored,
      :type_of_sairan_cycle,
      :types_of_fertilization_methods,
      :number_of_fertilized_eggs,
      :number_of_frozen_eggs,
      :content,
      :successful_egg_maturity,
      :successful_embryo_culture_days,
      :successful_embryo_grade_quality,
      :successful_embryo_grade_size,
      :successful_ova_with_ivm,
      :clinic_id,
      :cost,
      :credit_card_validity,
      :clinic_selection_criteria,
      :clinic_review,
      :successful_embryo_grade_quality,
      :successful_embryo_grade_size,
      :successful_ova_with_ivm,
      :average_waiting_time,
      :smoking,
      :period_of_time_spent_traveling,
      :using_the_support_system,
      :scope_of_disclosure,
      :content,
      tag_ids: []
      )
    end
end
