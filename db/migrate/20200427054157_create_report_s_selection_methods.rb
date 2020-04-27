class CreateReportSSelectionMethods < ActiveRecord::Migration[6.0]
  def change
    create_table :report_s_selection_methods do |t|
      t.references :report, null: false, foreign_key: true
      t.references :s_selection_method, null: false, foreign_key: true

      t.timestamps
    end
  end
end
