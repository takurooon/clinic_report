class CreateSairanMedicines < ActiveRecord::Migration[6.0]
  def change
    create_table :sairan_medicines do |t|
      t.string :name

      t.timestamps
    end
  end
end