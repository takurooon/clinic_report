class CreateRegion1s < ActiveRecord::Migration[6.0]
  def change
    create_table :region1s do |t|
      t.string :name

      t.timestamps
    end
  end
end
