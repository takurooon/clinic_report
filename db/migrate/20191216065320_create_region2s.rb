class CreateRegion2s < ActiveRecord::Migration[6.0]
  def change
    create_table :region2s do |t|
      t.string :name

      t.timestamps
    end
  end
end
