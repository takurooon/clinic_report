class CreateTreatmentSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :treatment_schedules do |t|
      t.references :report, null: false, foreign_key: true
      t.integer :day
      t.integer :cycle
      t.integer :exam_headline

      t.timestamps
    end
  end
end