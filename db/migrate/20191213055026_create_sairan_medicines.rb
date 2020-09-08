class CreateSairanMedicines < ActiveRecord::Migration[6.0]
  def change
    create_table :sairan_medicines do |t|
      t.string :name
      t.string :yomigana

      t.timestamps
    end
  end
end
