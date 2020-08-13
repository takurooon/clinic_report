class AddSeireishiteiIdToCity < ActiveRecord::Migration[6.0]
  def change
    add_reference :cities, :seireishitei, null: false, foreign_key: true
  end
end
