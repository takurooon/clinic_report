class CreateSeireishiteis < ActiveRecord::Migration[6.0]
  def change
    create_table :seireishiteis do |t|
      t.string :name
      t.references :prefecture, optional: true, foreign_key: true

      t.timestamps
    end
  end
end
