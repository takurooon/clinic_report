class CreateOtherEfforts < ActiveRecord::Migration[6.0]
  def change
    create_table :other_efforts do |t|
      t.integer :name

      t.timestamps
    end
  end
end
