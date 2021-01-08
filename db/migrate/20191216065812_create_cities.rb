class CreateCities < ActiveRecord::Migration[6.0]
  def change
    create_table :cities do |t|
      t.string :name
      t.string :name_alphabet
      t.integer :code
      t.string :yomigana
      t.references :prefecture, null: false, foreign_key: true

      t.timestamps
    end
  end
end
