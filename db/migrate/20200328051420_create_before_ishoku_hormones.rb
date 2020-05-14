class CreateBeforeIshokuHormones < ActiveRecord::Migration[6.0]
  def change
    create_table :before_ishoku_hormones do |t|
      t.references :report, null: false, foreign_key: true
      t.integer :day, null: false
      t.float :e2
      t.float :fsh
      t.float :lh
      t.float :p4

      t.timestamps
    end
    add_index :before_ishoku_hormones, [:report_id,:day], unique: true
  end
end
