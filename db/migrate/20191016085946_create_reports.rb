class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.string :title
      t.integer :current_state
      t.date :year_of_treatment_end
      t.integer :fertility_treatment_number
      t.integer :number_of_clinics
      t.integer :clinic_selection_criteria
      t.integer :treatment_type
      t.integer :treatment_start_age
      t.integer :first_age_to_start
      t.integer :treatment_end_age
      t.integer :treatment_period
      t.integer :number_of_aih
      t.integer :amh
      t.integer :bmi
      t.integer :smoking
      t.integer :types_of_eggs_and_sperm
      t.integer :type_of_sairan_cycle
      t.integer :total_number_of_sairan
      t.integer :all_number_of_sairan
      t.integer :number_of_eggs_collected
      t.integer :egg_maturity
      t.integer :ova_with_ivm
      t.integer :types_of_fertilization_methods
      t.integer :number_of_fertilized_eggs
      t.integer :number_of_frozen_eggs
      t.integer :embryo_culture_days
      t.integer :embryo_stage
      t.integer :early_embryo_grade
      t.integer :blastocyst_grade1
      t.integer :blastocyst_grade2
      t.integer :total_number_of_transplants
      t.integer :all_number_of_transplants
      t.integer :number_of_eggs_stored
      t.integer :cost
      t.integer :all_cost
      t.integer :credit_card_validity
      t.integer :average_waiting_time
      t.integer :reservation_method
      t.integer :period_of_time_spent_traveling
      t.integer :work_style
      t.integer :industry_type
      t.integer :private_or_listed_company
      t.integer :domestic_or_foreign_capital
      t.integer :capital_size
      t.integer :department
      t.integer :position
      t.integer :annual_income
      t.integer :household_net_income
      t.integer :number_of_employees
      t.integer :treatment_support_system
      t.integer :suspended_or_retirement_job
      t.text :content
      t.text :clinic_review
      t.text :reasons_for_choosing_this_clinic
      t.integer :status, default: 1, null: false
      t.integer :annual_income_status, default: 0, null: false
      t.integer :household_net_income_status, default: 0, null: false
      t.timestamps
    end
  end
end
