class CreateItineraryOfChoosingAClinics < ActiveRecord::Migration[6.0]
  def change
    create_table :itinerary_of_choosing_a_clinics do |t|
      t.references :report, null: false, foreign_key: true
      t.references :clinic, null: false, foreign_key: true
      t.integer :order_of_transfer

      t.timestamps
    end
  end
end