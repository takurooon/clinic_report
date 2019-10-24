class CreateReportTransferOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :report_transfer_options do |t|
      t.references :report, null: false, foreign_key: true
      t.references :transfer_option, null: false, foreign_key: true

      t.timestamps
    end
  end
end
