class CreateReportProgestinEplenishments < ActiveRecord::Migration[6.0]
  def change
    create_table :report_progestin_eplenishments do |t|
      t.references :report, null: false, foreign_key: true
      t.references :progestin_eplenishment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
