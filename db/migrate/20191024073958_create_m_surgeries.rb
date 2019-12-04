class CreateMSurgeries < ActiveRecord::Migration[6.0]
  def change
    create_table :m_surgeries do |t|
      t.string :name

      t.timestamps
    end
  end
end
