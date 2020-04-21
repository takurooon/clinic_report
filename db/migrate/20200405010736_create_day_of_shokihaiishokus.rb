class CreateDayOfShokihaiishokus < ActiveRecord::Migration[6.0]
  def change
    create_table :day_of_shokihaiishokus do |t|
      t.references :report, null: false, foreign_key: true
      t.integer :day, null: false
      t.integer :e2
      t.integer :fsh
      t.integer :lh
      t.integer :p4
      t.integer :endometrial_thickness

      t.timestamps
    end
    add_index :day_of_shokihaiishokus, [:report_id,:day], unique: true
  end
end
