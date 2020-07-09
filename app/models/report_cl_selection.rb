class ReportClSelection < ApplicationRecord
  belongs_to :report
  belongs_to :cl_selection
end

# == Schema Information
#
# Table name: report_cl_selections
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  cl_selection_id :bigint           not null
#  report_id       :bigint           not null
#
# Indexes
#
#  index_report_cl_selections_on_cl_selection_id  (cl_selection_id)
#  index_report_cl_selections_on_report_id        (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (cl_selection_id => cl_selections.id)
#  fk_rails_...  (report_id => reports.id)
#
