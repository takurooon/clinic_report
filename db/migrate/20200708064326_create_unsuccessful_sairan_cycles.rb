class CreateUnsuccessfulSairanCycles < ActiveRecord::Migration[6.0]
  def change
    create_table :unsuccessful_sairan_cycles do |t|
      t.references :report, null: false, foreign_key: true
      t.integer :un_sairan_number
      t.integer :un_sairan_age
      t.integer :un_sairan_type_of_ovarian_stimulation
      t.integer :un_sairan_number_of_eggs_collected
      t.integer :un_sairan_number_of_fertilized_eggs
      t.integer :un_sairan_number_of_transferable_embryos
      t.integer :un_sairan_number_of_frozen_eggs
      t.text :un_sairan_memo

      t.timestamps
    end
  end
end
