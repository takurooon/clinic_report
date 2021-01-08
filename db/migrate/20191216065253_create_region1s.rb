class CreateRegion1s < ActiveRecord::Migration[6.0]
  def change
    create_table :region1s do |t|
      t.string :name
      t.string :name_alphabet

      t.timestamps
    end
  end
end
