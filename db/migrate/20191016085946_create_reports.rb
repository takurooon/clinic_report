class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.string :title
      t.integer :current_state
      t.date :year_of_treatment_end
      t.integer :fertility_treatment_number
      t.integer :transplant_method
      t.text :transplant_method_memo
      t.integer :number_of_clinics
      t.integer :briefing_session
      t.integer :treatment_start_age
      t.integer :treatment_end_age
      t.integer :age_of_partner_at_end_of_treatment
      t.integer :treatment_period
      t.integer :amh
      t.integer :sairan_age
      t.integer :ishoku_age
      t.integer :type_of_ovarian_stimulation
      t.text :type_of_ovarian_stimulation_memo
      t.integer :use_of_anesthesia
      t.integer :selection_of_anesthesia_type
      t.integer :total_number_of_sairan
      t.integer :number_of_eggs_collected
      t.integer :ova_with_ivm
      t.integer :types_of_fertilization_methods
      t.integer :details_of_icsi
      t.integer :number_of_fertilized_eggs
      t.integer :number_of_transferable_embryos
      t.integer :number_of_frozen_eggs
      t.integer :embryo_stage
      t.integer :early_embryo_grade
      t.text :early_embryo_grade_supplementary_explanation
      t.integer :blastocyst_grade1
      t.text :blastocyst_grade1_supplementary_explanation
      t.integer :blastocyst_grade2
      t.text :blastocyst_grade2_supplementary_explanation
      t.text :explanation_and_impression_about_sairan
      t.integer :ishoku_type
      t.text :ishoku_type_memo
      t.integer :total_number_of_transplants
      t.integer :total_number_of_eggs_transplanted
      t.integer :number_of_eggs_stored
      t.text :explanation_and_impression_about_ishoku
      t.integer :fuiku
      t.text :fuiku_supplementary_explanation
      t.integer :f_other_effort_cost
      t.integer :m_other_effort_cost
      t.text :f_other_effort_memo
      t.text :m_other_effort_memo
      t.integer :sairan_cost
      t.text :sairan_cost_explanation
      t.integer :ishoku_cost
      t.text :ishoku_cost_explanation
      t.integer :cost
      t.text :explanation_of_cost
      t.integer :credit_card_validity
      t.integer :creditcards_can_be_used_from_more_than
      t.integer :average_waiting_time
      t.float :average_waiting_time2
      t.integer :online_consultation
      t.text :online_consultation_details
      t.integer :period_of_time_spent_traveling
      t.integer :work_style
      t.integer :work_style_status, default: 0, null: false
      t.integer :household_net_income
      t.integer :treatment_support_system
      t.integer :suspended_or_retirement_job
      t.text :content
      t.float :staff_quality
      t.float :doctor_quality
      t.float :impression_of_price
      t.float :impression_of_technology
      t.float :comfort_of_space
      t.text :clinic_review
      t.text :reasons_for_choosing_this_clinic
      t.integer :status, default: 0, null: false
      t.integer :prefecture_at_the_time_status, default: 0, null: false
      t.integer :city_at_the_time_status, default: 0, null: false
      t.integer :household_net_income_status, default: 0, null: false
      t.integer :rest_period
      t.text :rest_period_memo
      t.text :reason_for_transfer
      t.text :treatment_policy
      t.integer :number_of_visits_before_sairan
      t.integer :number_of_visits_before_ishoku
      t.text :transfer_option_memo
      t.integer :free_wifi
      t.integer :possible_to_wait_outside_cl

      t.timestamps
    end
  end
end
