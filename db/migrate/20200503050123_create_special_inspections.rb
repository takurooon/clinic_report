class CreateSpecialInspections < ActiveRecord::Migration[6.0]
  def change
    create_table :special_inspections do |t|
      t.references :report, null: false, foreign_key: true
      t.integer :name
      t.integer :place

      t.timestamps
    end
  end
end
