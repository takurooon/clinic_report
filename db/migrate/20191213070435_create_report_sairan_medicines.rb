class CreateReportSairanMedicines < ActiveRecord::Migration[6.0]
  def change
    create_table :report_sairan_medicines do |t|
      t.references :report, null: false, foreign_key: true
      t.references :sairan_medicine, null: false, foreign_key: true

      t.timestamps
    end
  end
end
