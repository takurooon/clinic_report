class CreateReportClMaleInspections < ActiveRecord::Migration[6.0]
  def change
    create_table :report_cl_male_inspections do |t|
      t.references :report, null: false, foreign_key: true
      t.references :cl_male_inspection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
