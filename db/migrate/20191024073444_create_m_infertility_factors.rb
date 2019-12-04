class CreateMInfertilityFactors < ActiveRecord::Migration[6.0]
  def change
    create_table :m_infertility_factors do |t|
      t.string :name

      t.timestamps
    end
  end
end
