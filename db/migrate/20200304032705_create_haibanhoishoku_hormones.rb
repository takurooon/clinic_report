class CreateHaibanhoishokuHormones < ActiveRecord::Migration[6.0]
  def change
    create_table :haibanhoishoku_hormones do |t|
      t.references :report, null: false, foreign_key: true
      t.integer :bt, null: false
      t.integer :e2
      t.integer :fsh
      t.integer :lh
      t.integer :p4
      t.integer :hcg

      t.timestamps
    end
    add_index :haibanhoishoku_hormones, [:report_id,:bt], unique: true
  end
end
