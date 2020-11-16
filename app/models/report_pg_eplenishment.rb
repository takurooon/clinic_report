class ReportPgEplenishment < ApplicationRecord
  belongs_to :report
  belongs_to :pg_eplenishment
end

# == Schema Information
#
# Table name: report_pg_eplenishments
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  pg_eplenishment_id :bigint           not null
#  report_id          :bigint           not null
#
# Indexes
#
#  index_report_pg_eplenishments_on_pg_eplenishment_id  (pg_eplenishment_id)
#  index_report_pg_eplenishments_on_report_id           (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (pg_eplenishment_id => pg_eplenishments.id)
#  fk_rails_...  (report_id => reports.id)
#
