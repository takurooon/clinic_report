class CreateReportOvulationInducers < ActiveRecord::Migration[6.0]
  def change
    create_table :report_ovulation_inducers do |t|
      t.references :report, null: false, foreign_key: true
      t.references :ovulation_inducer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
