class CreateSupplements < ActiveRecord::Migration[6.0]
  def change
    create_table :supplements do |t|
      t.integer :name

      t.timestamps
    end
  end
end
