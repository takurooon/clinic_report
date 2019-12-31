class CreateReportInspections < ActiveRecord::Migration[6.0]
  def change
    create_table :report_inspections do |t|
      t.references :report, null: false, foreign_key: true
      t.references :inspection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
