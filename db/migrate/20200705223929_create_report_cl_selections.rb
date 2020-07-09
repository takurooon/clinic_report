class CreateReportClSelections < ActiveRecord::Migration[6.0]
  def change
    create_table :report_cl_selections do |t|
      t.references :report, null: false, foreign_key: true
      t.references :cl_selection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
