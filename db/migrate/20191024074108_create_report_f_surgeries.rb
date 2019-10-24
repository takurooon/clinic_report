class CreateReportFSurgeries < ActiveRecord::Migration[6.0]
  def change
    create_table :report_f_surgeries do |t|
      t.references :report, null: false, foreign_key: true
      t.references :f_surgery, null: false, foreign_key: true

      t.timestamps
    end
  end
end
