class AddPrefectureIdToClinic < ActiveRecord::Migration[6.0]
  def change
    add_reference :clinics, :prefecture, null: false, foreign_key: true
  end
end
