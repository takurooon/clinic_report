class DayOfHaibanhoishoku < ApplicationRecord
  belongs_to :report

  validates :bt, presence: true, numericality: true
end

# == Schema Information
#
# Table name: day_of_haibanhoishokus
#
#  id         :bigint           not null, primary key
#  bt         :integer          default(0), not null
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
#  index_day_of_haibanhoishokus_on_report_id         (report_id)
#  index_day_of_haibanhoishokus_on_report_id_and_bt  (report_id,bt) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (report_id => reports.id)
#
