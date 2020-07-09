class CreateUnsuccessfulSairanCycles < ActiveRecord::Migration[6.0]
  def change
    create_table :unsuccessful_sairan_cycles do |t|
      t.references :report, null: false, foreign_key: true
      t.integer :number
      t.integer :sairan_age
      t.integer :type_of_ovarian_stimulation
      t.integer :number_of_eggs_collected
      t.integer :number_of_fertilized_eggs
      t.integer :number_of_transferable_embryos
      t.integer :number_of_frozen_eggs
      t.text :memo

      t.timestamps
    end
  end
end
