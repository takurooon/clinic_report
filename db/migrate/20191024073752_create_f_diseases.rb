class CreateFDiseases < ActiveRecord::Migration[6.0]
  def change
    create_table :f_diseases do |t|
      t.string :name
      t.string :yomigana

      t.timestamps
    end
  end
end
