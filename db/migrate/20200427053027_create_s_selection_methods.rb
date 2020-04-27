class CreateSSelectionMethods < ActiveRecord::Migration[6.0]
  def change
    create_table :s_selection_methods do |t|
      t.string :name

      t.timestamps
    end
  end
end
