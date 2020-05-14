class CreateDayOfHaibanhoishokus < ActiveRecord::Migration[6.0]
  def change
    create_table :day_of_haibanhoishokus do |t|
      t.references :report, null: false, foreign_key: true
      t.integer :day, null: false
      t.float :e2
      t.float :fsh
      t.float :lh
      t.float :p4
      t.float :endometrial_thickness

      t.timestamps
    end
    add_index :day_of_haibanhoishokus, [:report_id,:day], unique: true
  end
end
