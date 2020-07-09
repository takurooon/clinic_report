class CreateReportCostBurdens < ActiveRecord::Migration[6.0]
  def change
    create_table :report_cost_burdens do |t|
      t.references :report, null: false, foreign_key: true
      t.references :cost_burden, null: false, foreign_key: true

      t.timestamps
    end
  end
end
