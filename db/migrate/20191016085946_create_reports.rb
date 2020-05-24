class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.string :title
      t.integer :current_state
      t.date :year_of_treatment_end
      t.integer :fertility_treatment_number
      t.integer :transplant_method
      t.integer :number_of_clinics
      t.integer :clinic_selection_criteria
      t.integer :briefing_session
      t.integer :treatment_start_age
      t.integer :first_age_to_start
      t.integer :treatment_end_age
      t.integer :age_of_partner_at_end_of_treatment
      t.integer :treatment_period
      t.integer :number_of_aih
      t.text :inspection_supplementary_explanation
      t.integer :pgt1
      t.integer :pgt1_status
      t.integer :pgt2
      t.integer :pgt2_status
      t.text :pgt_supplementary_explanation
      t.integer :pgt_supplementary_explanation_status
      t.text :about_causes_of_infertility
      t.float :semen_volume
      t.integer :semen_concentration
      t.float :sperm_advance_rate
      t.float :sperm_motility
      t.float :probability_of_normal_morphology_of_sperm
      t.integer :total_amount_of_sperm
      t.text :sperm_description
      t.integer :amh
      t.integer :bmi
      t.integer :smoking
      t.integer :types_of_eggs_and_sperm
      t.text :description_of_eggs_and_sperm_used
      t.integer :sairan_age
      t.integer :ishoku_age
      t.integer :type_of_ovarian_stimulation
      t.integer :type_of_sairan_cycle
      t.text :notes_on_type_of_sairan_cycle
      t.integer :use_of_anesthesia
      t.integer :selection_of_anesthesia_type
      t.integer :total_number_of_sairan
      t.integer :all_number_of_sairan
      t.integer :number_of_eggs_collected
      t.integer :egg_maturity
      t.integer :ova_with_ivm
      t.integer :types_of_fertilization_methods
      t.integer :details_of_icsi
      t.integer :number_of_fertilized_eggs
      t.integer :number_of_transferable_embryos
      t.integer :number_of_frozen_eggs
      t.integer :embryo_culture_days
      t.integer :embryo_stage
      t.integer :early_embryo_grade
      t.text :early_embryo_grade_supplementary_explanation
      t.integer :blastocyst_grade1
      t.text :blastocyst_grade1_supplementary_explanation
      t.integer :blastocyst_grade2
      t.text :blastocyst_grade2_supplementary_explanation
      t.text :explanation_and_impression_about_sairan
      t.integer :total_number_of_transplants
      t.integer :total_number_of_eggs_transplanted
      t.integer :all_number_of_transplants
      t.integer :number_of_eggs_stored
      t.integer :frozen_embryo_storage_cost
      t.text :explanation_of_frozen_embryo_storage_cost
      t.text :explanation_and_impression_about_ishoku
      t.integer :number_of_miscarriages
      t.integer :number_of_stillbirths
      t.integer :fuiku
      t.text :fuiku_supplementary_explanation
      t.integer :adoption
      t.integer :other_effort_cost
      t.text :other_effort_supplementary_explanation
      t.integer :supplement_cost
      t.text :supplement_supplementary_explanation
      t.integer :sairan_cost
      t.text :sairan_cost_explanation
      t.integer :ishoku_cost
      t.text :ishoku_cost_explanation
      t.integer :cost
      t.text :explanation_of_cost
      t.integer :all_cost
      t.integer :number_of_times_the_grant_was_received
      t.integer :all_grant_amount
      t.text :supplementary_explanation_of_grant
      t.integer :credit_card_validity
      t.integer :creditcards_can_be_used_from_more_than
      t.integer :average_waiting_time
      t.integer :reservation_method
      t.integer :online_consultation
      t.text :online_consultation_details
      t.integer :period_of_time_spent_traveling
      t.integer :work_style
      t.integer :work_style_status
      t.integer :industry_type
      t.integer :industry_type_status
      t.integer :private_or_listed_company
      t.integer :private_or_listed_company_status
      t.integer :domestic_or_foreign_capital
      t.integer :domestic_or_foreign_capital_status
      t.integer :capital_size
      t.integer :capital_size_status
      t.integer :department
      t.integer :department_status
      t.integer :position
      t.integer :position_status
      t.integer :annual_income
      t.integer :household_net_income
      t.integer :number_of_employees
      t.integer :number_of_employees_status
      t.integer :treatment_support_system
      t.integer :suspended_or_retirement_job
      t.text :about_work_and_working_style
      t.text :content
      t.integer :staff_quality
      t.integer :doctor_quality
      t.integer :impression_of_price
      t.integer :impression_of_technology
      t.integer :comfort_of_space
      t.text :clinic_review
      t.text :reasons_for_choosing_this_clinic
      t.integer :status, default: 0, null: false
      t.integer :prefecture_at_the_time_status, default: 0, null: false
      t.integer :city_at_the_time_status, default: 0, null: false
      t.integer :annual_income_status, default: 0, null: false
      t.integer :household_net_income_status, default: 0, null: false
      t.timestamps
    end
  end
end
