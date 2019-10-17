class AddLatestClinicReviewIdToReports < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :latest_clinic_review_id, :integer
  end
end
