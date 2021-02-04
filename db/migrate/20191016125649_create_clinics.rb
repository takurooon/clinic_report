class CreateClinics < ActiveRecord::Migration[6.0]
  def change
    create_table :clinics do |t|
      t.string :name
      t.integer :jsog_code
      t.string :post_code
      t.string :address1
      t.string :address2
      t.string :tel
      t.text :g_map
      t.integer :senkoishido
      t.integer :fujinkashuyo
      t.integer :shusanki
      t.integer :ivf
      t.integer :hai_ranshi_toketsu
      t.integer :kenbijusei
      t.integer :social_ranshitoketsu
      t.integer :teikyoseishi_aih
      t.integer :pgt
      t.integer :jis_art
      t.integer :japco
      t.integer :senmon
      t.integer :current_status
      t.integer :jsog_status
      t.string :yomigana

      t.timestamps
    end
  end
end
