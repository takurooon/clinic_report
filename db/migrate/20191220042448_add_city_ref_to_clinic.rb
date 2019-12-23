class AddCityRefToClinic < ActiveRecord::Migration[6.0]
  def change
    add_reference :clinics, :city, null: false, foreign_key: true
  end
end
