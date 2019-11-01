class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.string :title 
      t.integer :fertility_treatment_number
      t.integer :treatment_type
      t.integer :current_state
      t.integer :work_style
      t.integer :number_of_employees
      t.integer :number_of_clinics
      t.integer :address_at_that_time
      t.integer :number_of_aih
      t.integer :treatment_start_age
      t.integer :treatment_end_age
      t.integer :treatment_period
      t.integer :amh
      t.integer :bmi
      t.integer :types_of_eggs_and_sperm
      t.integer :total_number_of_sairan
      t.integer :number_of_eggs_collected
      t.integer :total_number_of_transplants
      t.integer :number_of_eggs_stored
      t.integer :type_of_sairan_cycle
      t.integer :types_of_fertilization_methods
      t.integer :number_of_fertilized_eggs
      t.integer :number_of_frozen_eggs
      t.integer :cost
      t.integer :credit_card_validity
      t.integer :clinic_selection_criteria
      t.integer :successful_egg_maturity
      t.integer :successful_embryo_culture_days
      t.integer :successful_embryo_grade_quality
      t.integer :successful_embryo_grade_size
      t.integer :successful_ova_with_ivm
      t.integer :average_waiting_time
      t.integer :smoking
      t.integer :period_of_time_spent_traveling
      t.integer :using_the_support_system
      t.integer :scope_of_disclosure
      t.text :content
      t.text :clinic_review
      t.timestamps
    end
  end
end
