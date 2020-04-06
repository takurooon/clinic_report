class CreateDayOfSairans < ActiveRecord::Migration[6.0]
  def change
    create_table :day_of_sairans do |t|
      t.references :report, null: false, foreign_key: true
      t.integer :day, null: false
      t.integer :e2
      t.integer :fsh
      t.integer :lh
      t.integer :p4

      t.timestamps
    end
    add_index :day_of_sairans, [:report_id,:day], unique: true
  end
end
