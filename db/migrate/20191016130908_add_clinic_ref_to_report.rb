class AddClinicRefToReport < ActiveRecord::Migration[6.0]
  def change
    add_reference :reports, :clinic, null: false, foreign_key: true
  end
end
