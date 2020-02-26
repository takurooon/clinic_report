class CreateShinsenhaiishokuHormones < ActiveRecord::Migration[6.0]
  def change
    create_table :shinsenhaiishoku_hormones do |t|
      t.references :report, null: false, foreign_key: true
      t.integer :day
      t.integer :e2
      t.integer :fsh
      t.integer :lh
      t.integer :p4

      t.timestamps
    end
    add_index :shinsenhaiishoku_hormones, [:report_id,:day], unique: true
  end
end
