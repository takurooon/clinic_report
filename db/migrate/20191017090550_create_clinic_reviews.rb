class CreateClinicReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :clinic_reviews do |t|
      t.references :clinic, null: false, foreign_key: true
      t.references :report, null: false, foreign_key: true
      t.integer :cost
      t.integer :credit_card_validity
      t.integer :clinic_selection_criteria
      t.integer :average_waiting_time

      t.timestamps
    end
  end
end
