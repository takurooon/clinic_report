class CreateFFuninFactors < ActiveRecord::Migration[6.0]
  def change
    create_table :f_funin_factors do |t|
      t.string :name

      t.timestamps
    end
  end
end
