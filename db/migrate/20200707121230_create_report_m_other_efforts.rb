class CreateReportMOtherEfforts < ActiveRecord::Migration[6.0]
  def change
    create_table :report_m_other_efforts do |t|
      t.references :report, null: false, foreign_key: true
      t.references :m_other_effort, null: false, foreign_key: true

      t.timestamps
    end
  end
end
