class CreateUnsuccessfulIshokuCycles < ActiveRecord::Migration[6.0]
  def change
    create_table :unsuccessful_ishoku_cycles do |t|
      t.references :report, null: false, foreign_key: true
      t.integer :un_ishoku_number
      t.integer :un_ishoku_age
      t.integer :un_ishoku_transplant_method
      t.integer :un_ishoku_type
      t.text :un_ishoku_memo

      t.timestamps
    end
  end
end
