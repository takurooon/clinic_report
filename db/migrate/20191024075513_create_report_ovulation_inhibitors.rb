class CreateReportOvulationInhibitors < ActiveRecord::Migration[6.0]
  def change
    create_table :report_ovulation_inhibitors do |t|
      t.references :report, null: false, foreign_key: true
      t.references :ovulation_inhibitor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
