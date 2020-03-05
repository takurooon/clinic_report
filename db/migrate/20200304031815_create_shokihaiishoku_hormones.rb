class CreateShokihaiishokuHormones < ActiveRecord::Migration[6.0]
  def change
    create_table :shokihaiishoku_hormones do |t|
      t.references :report, null: false, foreign_key: true
      t.integer :et
      t.integer :e2
      t.integer :fsh
      t.integer :lh
      t.integer :p4
      t.integer :hcg

      t.timestamps
    end
    add_index :shokihaiishoku_hormones, [:report_id,:et], unique: true
  end
end
