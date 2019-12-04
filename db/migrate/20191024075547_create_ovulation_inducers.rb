class CreateOvulationInducers < ActiveRecord::Migration[6.0]
  def change
    create_table :ovulation_inducers do |t|
      t.string :name

      t.timestamps
    end
  end
end
