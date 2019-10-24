class CreateTransferOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :transfer_options do |t|
      t.integer :name

      t.timestamps
    end
  end
end
