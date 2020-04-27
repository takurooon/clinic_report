class ReportSSelectionMethod < ApplicationRecord
  belongs_to :report
  belongs_to :s_selection_method
end

# == Schema Information
#
# Table name: report_s_selection_methods
#
#  id                    :bigint           not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  report_id             :bigint           not null
#  s_selection_method_id :bigint           not null
#
# Indexes
#
#  index_report_s_selection_methods_on_report_id              (report_id)
#  index_report_s_selection_methods_on_s_selection_method_id  (s_selection_method_id)
#
# Foreign Keys
#
#  fk_rails_...  (report_id => reports.id)
#  fk_rails_...  (s_selection_method_id => s_selection_methods.id)
#
