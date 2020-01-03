class AddColumnToReport < ActiveRecord::Migration[6.0]
  def change
    add_reference :reports, :prefecture, foreign_key: true
    add_reference :reports, :city, foreign_key: true
  end
end
