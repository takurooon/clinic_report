class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.string :title
      t.integer :current_state
      t.date :year_of_treatment_end
      t.integer :fertility_treatment_number
      t.integer :transplant_method
      t.integer :number_of_clinics
      t.integer :treatment_end_age
      t.integer :age_of_partner_at_end_of_treatment
      t.integer :treatment_period
      t.integer :amh
      t.integer :sairan_age
      t.integer :ishoku_age
      t.integer :type_of_ovarian_stimulation
      t.integer :use_of_anesthesia
      t.integer :selection_of_anesthesia_type
      t.integer :total_number_of_sairan
      t.integer :number_of_eggs_collected
      t.integer :egg_m2
      t.integer :egg_m1
      t.integer :egg_gv
      t.integer :ova_with_ivm
      t.integer :types_of_fertilization_methods
      t.integer :details_of_icsi
      t.integer :number_of_fertilized_eggs
      t.integer :number_of_transferable_embryos
      t.integer :embryo_stage
      t.integer :early_embryo_grade
      t.integer :blastocyst_grade1
      t.integer :blastocyst_grade2
      t.integer :ishoku_type
      t.integer :total_number_of_transplants
      t.integer :total_number_of_eggs_transplanted
      t.integer :fuiku
      t.integer :sairan_cost
      t.integer :ishoku_cost
      t.integer :cost
      t.integer :credit_card_validity
      t.integer :creditcards_can_be_used_from_more_than
      t.integer :staff_quality
      t.integer :doctor_quality
      t.integer :impression_of_price
      t.integer :impression_of_technology
      t.integer :comfort_of_space
      t.integer :average_waiting_time
      t.integer :average_waiting_time2
      t.text :clinic_review
      t.integer :period_of_time_spent_traveling
      t.integer :work_style
      t.integer :work_style_status, default: 0, null: false
      t.integer :switching_work_styles
      t.text :content
      t.text :reasons_for_choosing_this_clinic
      t.integer :status, default: 0, null: false
      t.integer :prefecture_at_the_time_status, default: 0, null: false
      t.integer :city_at_the_time_status, default: 0, null: false
      t.text :reason_for_transfer
      t.text :treatment_policy
      t.integer :number_of_visits_before_sairan
      t.integer :number_of_visits_before_ishoku
      t.integer :free_wifi
      t.integer :possible_to_wait_outside_cl
      t.integer :male_infertility
      t.integer :level_of_male_infertility
      t.integer :number_of_unfrozen_embryos
      t.integer :number_of_frozen_pronuclear_embryos
      t.integer :number_of_frozen_early_embryos
      t.integer :number_of_frozen_blastocysts
      t.integer :culture_days
      t.integer :choran
      t.text :explanation_of_costs

      t.timestamps
    end
  end
end
