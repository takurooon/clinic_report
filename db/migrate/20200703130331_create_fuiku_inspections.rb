class CreateFuikuInspections < ActiveRecord::Migration[6.0]
  def change
    create_table :fuiku_inspections do |t|
      t.string :name

      t.timestamps
    end
  end
end
