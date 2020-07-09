class CreateClMaleInspections < ActiveRecord::Migration[6.0]
  def change
    create_table :cl_male_inspections do |t|
      t.string :name

      t.timestamps
    end
  end
end
