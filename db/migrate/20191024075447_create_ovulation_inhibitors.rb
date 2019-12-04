class CreateOvulationInhibitors < ActiveRecord::Migration[6.0]
  def change
    create_table :ovulation_inhibitors do |t|
      t.string :name

      t.timestamps
    end
  end
end
