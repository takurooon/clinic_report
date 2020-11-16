class CreateReportPgEplenishments < ActiveRecord::Migration[6.0]
  def change
    create_table :report_pg_eplenishments do |t|
      t.references :report, null: false, foreign_key: true
      t.references :pg_eplenishment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
