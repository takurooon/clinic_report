class CreateReportMDiseases < ActiveRecord::Migration[6.0]
  def change
    create_table :report_m_diseases do |t|
      t.references :report, null: false, foreign_key: true
      t.references :m_disease, null: false, foreign_key: true

      t.timestamps
    end
  end
end
