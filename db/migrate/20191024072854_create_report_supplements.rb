class CreateReportSupplements < ActiveRecord::Migration[6.0]
  def change
    create_table :report_supplements do |t|
      t.references :report, null: false, foreign_key: true
      t.references :supplement, null: false, foreign_key: true

      t.timestamps
    end
  end
end
