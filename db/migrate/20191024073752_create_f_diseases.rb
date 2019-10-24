class CreateFDiseases < ActiveRecord::Migration[6.0]
  def change
    create_table :f_diseases do |t|
      t.integer :name

      t.timestamps
    end
  end
end
