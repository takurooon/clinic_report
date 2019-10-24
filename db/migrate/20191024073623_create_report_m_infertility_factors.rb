class CreateReportMInfertilityFactors < ActiveRecord::Migration[6.0]
  def change
    create_table :report_m_infertility_factors do |t|
      t.references :report, null: false, foreign_key: true
      t.references :m_infertility_factor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
