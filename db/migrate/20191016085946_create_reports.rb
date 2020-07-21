class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.string :title
      t.integer :current_state
      t.date :year_of_treatment_end
      t.integer :fertility_treatment_number
      t.integer :transplant_method
      t.integer :number_of_clinics
      t.integer :briefing_session
      t.integer :treatment_start_age
      t.integer :treatment_end_age
      t.integer :age_of_partner_at_end_of_treatment
      t.integer :treatment_period
      t.text :inspection_supplementary_explanation
      t.integer :pgt1
      t.integer :pgt1_status, default: 0, null: false
      t.integer :pgt2
      t.integer :pgt2_status, default: 0, null: false
      t.text :pgt_supplementary_explanation
      t.integer :pgt_supplementary_explanation_status, default: 0, null: false
      t.text :f_infertility_memo
      t.text :m_infertility_memo
      t.text :f_surgery_memo
      t.text :m_surgery_memo
      t.text :f_disease_memo
      t.text :m_disease_memo
      t.float :semen_volume
      t.integer :semen_concentration
      t.float :sperm_advance_rate
      t.float :sperm_motility
      t.float :probability_of_normal_morphology_of_sperm
      t.integer :total_amount_of_sperm
      t.text :sperm_description
      t.integer :amh
      t.integer :smoking_male
      t.integer :smoking_female
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
      t.integer :ishoku_type
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
      t.integer :f_supplement_cost
      t.integer :m_supplement_cost
      t.text :f_supplement_memo
      t.text :m_supplement_memo
      t.integer :sairan_cost
      t.text :sairan_cost_explanation
      t.integer :ishoku_cost
      t.text :ishoku_cost_explanation
      t.integer :cost
      t.text :explanation_of_cost
      t.integer :credit_card_validity
      t.integer :creditcards_can_be_used_from_more_than
      t.integer :average_waiting_time
      t.integer :average_waiting_time2
      t.integer :reservation_method
      t.integer :online_consultation
      t.text :online_consultation_details
      t.integer :period_of_time_spent_traveling
      t.integer :work_style
      t.integer :work_style_status, default: 0, null: false
      t.integer :industry_type
      t.integer :industry_type_status, default: 0, null: false
      t.integer :household_net_income
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
      t.integer :household_net_income_status, default: 0, null: false
      t.integer :rest_period
      t.text :rest_period_memo
      t.text :reason_for_transfer
      t.text :most_sad_thing
      t.integer :how_long_to_continue_treatment
      t.text :how_long_to_continue_treatment_memo
      t.text :inspection_supplementary_explanation_men
      t.integer :pregnancy_date
      t.text :pregnancy_date_memo
      t.text :treatment_policy
      t.text :cl_female_inspection_memo
      t.text :cl_male_inspection_memo
      t.integer :how_long_to_continue_treatment2
      t.integer :followup_investigation
      t.text :followup_investigation_memo
      t.text :treatment_schedule_memo
      t.text :special_inspection_memo
      t.text :cost_burden_memo
      t.integer :number_of_visits_before_sairan
      t.integer :number_of_visits_before_ishoku
      t.integer :number_of_visits_before_pregnancy_date

      t.timestamps
    end
  end
end
