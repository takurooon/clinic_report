class RemoveColumnFromReports < ActiveRecord::Migration[6.0]
  def change
    remove_column :reports, :clinic_id, :bigint
    remove_column :reports, :cost, :integer
    remove_column :reports, :credit_card_validity, :integer
    remove_column :reports, :clinic_selection_criteria, :integer
  end
end
