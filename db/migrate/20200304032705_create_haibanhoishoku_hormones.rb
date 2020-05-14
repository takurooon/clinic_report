class CreateHaibanhoishokuHormones < ActiveRecord::Migration[6.0]
  def change
    create_table :haibanhoishoku_hormones do |t|
      t.references :report, null: false, foreign_key: true
      t.integer :bt, null: false
      t.float :e2
      t.float :fsh
      t.float :lh
      t.float :p4
      t.float :hcg

      t.timestamps
    end
    add_index :haibanhoishoku_hormones, [:report_id,:bt], unique: true
  end
end
