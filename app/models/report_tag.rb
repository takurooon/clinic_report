class ReportTag < ApplicationRecord
  belongs_to :report
  belongs_to :tag

end

# == Schema Information
#
# Table name: report_tags
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  report_id  :bigint           not null
#  tag_id     :bigint           not null
#
# Indexes
#
#  index_report_tags_on_report_id  (report_id)
#  index_report_tags_on_tag_id     (tag_id)
#
# Foreign Keys
#
#  fk_rails_...  (report_id => reports.id)
#  fk_rails_...  (tag_id => tags.id)
#
