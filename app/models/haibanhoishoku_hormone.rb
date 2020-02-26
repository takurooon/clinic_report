class HaibanhoishokuHormone < ApplicationRecord
  belongs_to :report
end

# == Schema Information
#
# Table name: haibanhoishoku_hormones
#
#  id         :bigint           not null, primary key
#  day        :integer
#  e2         :integer
#  fsh        :integer
#  lh         :integer
#  p4         :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  report_id  :bigint           not null
#
# Indexes
#
#  index_haibanhoishoku_hormones_on_report_id          (report_id)
#  index_haibanhoishoku_hormones_on_report_id_and_day  (report_id,day) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (report_id => reports.id)
#
