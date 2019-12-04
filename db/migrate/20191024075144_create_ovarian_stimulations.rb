class CreateOvarianStimulations < ActiveRecord::Migration[6.0]
  def change
    create_table :ovarian_stimulations do |t|
      t.string :name

      t.timestamps
    end
  end
end
