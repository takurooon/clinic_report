class CreateFInfertilityFactors < ActiveRecord::Migration[6.0]
  def change
    create_table :f_infertility_factors do |t|
      t.integer :name

      t.timestamps
    end
  end
end
