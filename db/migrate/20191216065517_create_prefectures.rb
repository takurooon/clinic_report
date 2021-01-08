class CreatePrefectures < ActiveRecord::Migration[6.0]
  def change
    create_table :prefectures do |t|
      t.string :name
      t.string :name_alphabet
      t.references :region1, null: false, foreign_key: true

      t.timestamps
    end
  end
end
