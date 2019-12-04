class CreateReportScopeOfDisclosures < ActiveRecord::Migration[6.0]
  def change
    create_table :report_scope_of_disclosures do |t|
      t.references :report, null: false, foreign_key: true
      t.references :scope_of_disclosure, null: false, foreign_key: true

      t.timestamps
    end
  end
end
