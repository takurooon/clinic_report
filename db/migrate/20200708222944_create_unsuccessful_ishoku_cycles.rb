class CreateUnsuccessfulIshokuCycles < ActiveRecord::Migration[6.0]
  def change
    create_table :unsuccessful_ishoku_cycles do |t|
      t.references :report, null: false, foreign_key: true
      t.integer :number
      t.integer :ishoku_age
      t.integer :transplant_method
      t.integer :ishoku_type
      t.text :memo

      t.timestamps
    end
  end
end
