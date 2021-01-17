class CreateClSelections < ActiveRecord::Migration[6.0]
  def change
    create_table :cl_selections do |t|
      t.string :name
      t.string :yomigana

      t.timestamps
    end
  end
end
