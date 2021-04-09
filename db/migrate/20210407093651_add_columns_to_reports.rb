class AddColumnsToReports < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :multiple_birth, :integer
    add_column :reports, :egg_unknown, :integer
    add_column :reports, :unknown_number_of_frozen_embryos, :integer
    add_column :reports, :unknown_unfrozen_or_frozen_embryos, :integer
    add_column :reports, :transplant_method_2, :integer
    add_column :reports, :embryo_stage_2, :integer
    add_column :reports, :blastocyst_grade1_2, :integer
    add_column :reports, :blastocyst_grade2_2, :integer
    add_column :reports, :culture_days_2, :integer
    add_column :reports, :early_embryo_grade_2, :integer
  end
end
