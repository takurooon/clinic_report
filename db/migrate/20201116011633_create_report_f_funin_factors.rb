class CreateReportFFuninFactors < ActiveRecord::Migration[6.0]
  def change
    create_table :report_f_funin_factors do |t|
      t.references :report, null: false, foreign_key: true
      t.references :f_funin_factor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
