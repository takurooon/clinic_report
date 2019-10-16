require "application_system_test_case"

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:one)
  end

  test "visiting the index" do
    visit reports_url
    assert_selector "h1", text: "Reports"
  end

  test "creating a Report" do
    visit reports_url
    click_on "New Report"

    fill_in "Address at that time", with: @report.address_at_that_time
    fill_in "Amh", with: @report.amh
    fill_in "Bmi", with: @report.bmi
    fill_in "Clinic selection criteria", with: @report.clinic_selection_criteria
    fill_in "Content", with: @report.content
    fill_in "Cost", with: @report.cost
    fill_in "Credit card validity", with: @report.credit_card_validity
    fill_in "Current state", with: @report.current_state
    fill_in "Fertility treatment number", with: @report.fertility_treatment_number
    fill_in "Number of aih", with: @report.number_of_aih
    fill_in "Number of clinics", with: @report.number_of_clinics
    fill_in "Number of eggs collected", with: @report.number_of_eggs_collected
    fill_in "Number of eggs stored", with: @report.number_of_eggs_stored
    fill_in "Number of fertilized eggs", with: @report.number_of_fertilized_eggs
    fill_in "Number of frozen eggs", with: @report.number_of_frozen_eggs
    fill_in "Successful egg maturity", with: @report.successful_egg_maturity
    fill_in "Successful embryo culture days", with: @report.successful_embryo_culture_days
    fill_in "Successful embryo grade", with: @report.successful_embryo_grade
    fill_in "Total number of sairan", with: @report.total_number_of_sairan
    fill_in "Total number of transplants", with: @report.total_number_of_transplants
    fill_in "Treatment end age", with: @report.treatment_end_age
    fill_in "Treatment period", with: @report.treatment_period
    fill_in "Treatment start age", with: @report.treatment_start_age
    fill_in "Treatment type", with: @report.treatment_type
    fill_in "Type of sairan cycle", with: @report.type_of_sairan_cycle
    fill_in "Types of eggs and sperm", with: @report.types_of_eggs_and_sperm
    fill_in "Types of fertilization methods", with: @report.types_of_fertilization_methods
    fill_in "Work style", with: @report.work_style
    click_on "Create Report"

    assert_text "Report was successfully created"
    click_on "Back"
  end

  test "updating a Report" do
    visit reports_url
    click_on "Edit", match: :first

    fill_in "Address at that time", with: @report.address_at_that_time
    fill_in "Amh", with: @report.amh
    fill_in "Bmi", with: @report.bmi
    fill_in "Clinic selection criteria", with: @report.clinic_selection_criteria
    fill_in "Content", with: @report.content
    fill_in "Cost", with: @report.cost
    fill_in "Credit card validity", with: @report.credit_card_validity
    fill_in "Current state", with: @report.current_state
    fill_in "Fertility treatment number", with: @report.fertility_treatment_number
    fill_in "Number of aih", with: @report.number_of_aih
    fill_in "Number of clinics", with: @report.number_of_clinics
    fill_in "Number of eggs collected", with: @report.number_of_eggs_collected
    fill_in "Number of eggs stored", with: @report.number_of_eggs_stored
    fill_in "Number of fertilized eggs", with: @report.number_of_fertilized_eggs
    fill_in "Number of frozen eggs", with: @report.number_of_frozen_eggs
    fill_in "Successful egg maturity", with: @report.successful_egg_maturity
    fill_in "Successful embryo culture days", with: @report.successful_embryo_culture_days
    fill_in "Successful embryo grade", with: @report.successful_embryo_grade
    fill_in "Total number of sairan", with: @report.total_number_of_sairan
    fill_in "Total number of transplants", with: @report.total_number_of_transplants
    fill_in "Treatment end age", with: @report.treatment_end_age
    fill_in "Treatment period", with: @report.treatment_period
    fill_in "Treatment start age", with: @report.treatment_start_age
    fill_in "Treatment type", with: @report.treatment_type
    fill_in "Type of sairan cycle", with: @report.type_of_sairan_cycle
    fill_in "Types of eggs and sperm", with: @report.types_of_eggs_and_sperm
    fill_in "Types of fertilization methods", with: @report.types_of_fertilization_methods
    fill_in "Work style", with: @report.work_style
    click_on "Update Report"

    assert_text "Report was successfully updated"
    click_on "Back"
  end

  test "destroying a Report" do
    visit reports_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Report was successfully destroyed"
  end
end
