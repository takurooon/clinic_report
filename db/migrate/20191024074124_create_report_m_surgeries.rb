class CreateReportMSurgeries < ActiveRecord::Migration[6.0]
  def change
    create_table :report_m_surgeries do |t|
      t.references :report, null: false, foreign_key: true
      t.references :m_surgery, null: false, foreign_key: true

      t.timestamps
    end
  end
end
