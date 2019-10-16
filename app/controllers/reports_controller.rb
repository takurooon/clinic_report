class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(report_params)

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(
        :fertility_treatment_number,
        :treatment_type,
        :current_state,
        :work_style,
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
        :cost, :credit_card_validity,
        :clinic_selection_criteria,
        :content,
        :successful_egg_maturity,
        :successful_embryo_culture_days,
        :successful_embryo_grade
        )
    end
end
