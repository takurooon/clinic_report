class CreateMOtherEfforts < ActiveRecord::Migration[6.0]
  def change
    create_table :m_other_efforts do |t|
      t.string :name
      t.string :yomigana

      t.timestamps
    end
  end
end
