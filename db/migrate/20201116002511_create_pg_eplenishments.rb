class CreatePgEplenishments < ActiveRecord::Migration[6.0]
  def change
    create_table :pg_eplenishments do |t|
      t.integer :name

      t.timestamps
    end
  end
end
