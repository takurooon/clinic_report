class CreateProgestinEplenishments < ActiveRecord::Migration[6.0]
  def change
    create_table :progestin_eplenishments do |t|
      t.integer :name

      t.timestamps
    end
  end
end
