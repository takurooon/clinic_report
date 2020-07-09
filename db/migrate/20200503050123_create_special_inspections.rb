class CreateSpecialInspections < ActiveRecord::Migration[6.0]
  def change
    create_table :special_inspections do |t|
      t.references :report, null: false, foreign_key: true
      t.integer :name, null: false
      t.integer :place
      t.integer :cost
      t.integer :timing

      t.timestamps
    end
  end
end
