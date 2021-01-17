class CreateTransferOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :transfer_options do |t|
      t.string :name
      t.string :yomigana
      t.integer :number

      t.timestamps
    end
  end
end
