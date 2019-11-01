class CreateClinicReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :clinic_reviews do |t|
      t.references :clinic, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :clinic_selection_criteria
      t.integer :average_waiting_time
      t.text :review

      t.timestamps
    end
  end
end
