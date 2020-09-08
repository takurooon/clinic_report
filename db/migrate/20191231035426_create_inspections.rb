class CreateInspections < ActiveRecord::Migration[6.0]
  def change
    create_table :inspections do |t|
      t.string :name
      t.string :yomigana

      t.timestamps
    end
  end
end
