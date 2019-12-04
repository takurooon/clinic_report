class CreateScopeOfDisclosures < ActiveRecord::Migration[6.0]
  def change
    create_table :scope_of_disclosures do |t|
      t.string :scope

      t.timestamps
    end
  end
end