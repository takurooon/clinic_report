class CreateShokihaiishokuHormones < ActiveRecord::Migration[6.0]
  def change
    create_table :shokihaiishoku_hormones do |t|
      t.references :report, null: false, foreign_key: true
      t.integer :et, null: false
      t.float :e2
      t.float :fsh
      t.float :lh
      t.float :p4
      t.float :hcg

      t.timestamps
    end
    add_index :shokihaiishoku_hormones, [:report_id,:et], unique: true
  end
end
