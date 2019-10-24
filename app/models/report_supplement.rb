class ReportSupplement < ApplicationRecord
  belongs_to :report
  belongs_to :supplement
end

# == Schema Information
#
# Table name: report_supplements
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  report_id     :bigint           not null
#  supplement_id :bigint           not null
#
# Indexes
#
#  index_report_supplements_on_report_id      (report_id)
#  index_report_supplements_on_supplement_id  (supplement_id)
#
# Foreign Keys
#
#  fk_rails_...  (report_id => reports.id)
#  fk_rails_...  (supplement_id => supplements.id)
#
