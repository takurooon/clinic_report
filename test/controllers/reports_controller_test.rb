require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @report = reports(:one)
  end

  test "should get index" do
    get reports_url
    assert_response :success
  end

  test "should get new" do
    get new_report_url
    assert_response :success
  end

  test "should create report" do
    assert_difference('Report.count') do
      post reports_url, params: { report: { address_at_that_time: @report.address_at_that_time, amh: @report.amh, bmi: @report.bmi, clinic_selection_criteria: @report.clinic_selection_criteria, content: @report.content, cost: @report.cost, credit_card_validity: @report.credit_card_validity, current_state: @report.current_state, fertility_treatment_number: @report.fertility_treatment_number, number_of_aih: @report.number_of_aih, number_of_clinics: @report.number_of_clinics, number_of_eggs_collected: @report.number_of_eggs_collected, number_of_eggs_stored: @report.number_of_eggs_stored, number_of_fertilized_eggs: @report.number_of_fertilized_eggs, number_of_frozen_eggs: @report.number_of_frozen_eggs, successful_egg_maturity: @report.successful_egg_maturity, successful_embryo_culture_days: @report.successful_embryo_culture_days, successful_embryo_grade: @report.successful_embryo_grade, total_number_of_sairan: @report.total_number_of_sairan, total_number_of_transplants: @report.total_number_of_transplants, treatment_end_age: @report.treatment_end_age, treatment_period: @report.treatment_period, treatment_start_age: @report.treatment_start_age, treatment_type: @report.treatment_type, type_of_sairan_cycle: @report.type_of_sairan_cycle, types_of_eggs_and_sperm: @report.types_of_eggs_and_sperm, types_of_fertilization_methods: @report.types_of_fertilization_methods, work_style: @report.work_style } }
    end

    assert_redirected_to report_url(Report.last)
  end

  test "should show report" do
    get report_url(@report)
    assert_response :success
  end

  test "should get edit" do
    get edit_report_url(@report)
    assert_response :success
  end

  test "should update report" do
    patch report_url(@report), params: { report: { address_at_that_time: @report.address_at_that_time, amh: @report.amh, bmi: @report.bmi, clinic_selection_criteria: @report.clinic_selection_criteria, content: @report.content, cost: @report.cost, credit_card_validity: @report.credit_card_validity, current_state: @report.current_state, fertility_treatment_number: @report.fertility_treatment_number, number_of_aih: @report.number_of_aih, number_of_clinics: @report.number_of_clinics, number_of_eggs_collected: @report.number_of_eggs_collected, number_of_eggs_stored: @report.number_of_eggs_stored, number_of_fertilized_eggs: @report.number_of_fertilized_eggs, number_of_frozen_eggs: @report.number_of_frozen_eggs, successful_egg_maturity: @report.successful_egg_maturity, successful_embryo_culture_days: @report.successful_embryo_culture_days, successful_embryo_grade: @report.successful_embryo_grade, total_number_of_sairan: @report.total_number_of_sairan, total_number_of_transplants: @report.total_number_of_transplants, treatment_end_age: @report.treatment_end_age, treatment_period: @report.treatment_period, treatment_start_age: @report.treatment_start_age, treatment_type: @report.treatment_type, type_of_sairan_cycle: @report.type_of_sairan_cycle, types_of_eggs_and_sperm: @report.types_of_eggs_and_sperm, types_of_fertilization_methods: @report.types_of_fertilization_methods, work_style: @report.work_style } }
    assert_redirected_to report_url(@report)
  end

  test "should destroy report" do
    assert_difference('Report.count', -1) do
      delete report_url(@report)
    end

    assert_redirected_to reports_url
  end
end
