class CreateReportOvarianStimulations < ActiveRecord::Migration[6.0]
  def change
    create_table :report_ovarian_stimulations do |t|
      t.references :report, null: false, foreign_key: true
      t.references :ovarian_stimulation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
