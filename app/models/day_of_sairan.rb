class DayOfSairan < ApplicationRecord
  belongs_to :report

  validates :day, presence: { message: 'を選択してください。' }
end

# == Schema Information
#
# Table name: day_of_sairans
#
#  id         :bigint           not null, primary key
#  day        :integer          not null
#  e2         :float
#  fsh        :float
#  lh         :float
#  p4         :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  report_id  :bigint           not null
#
# Indexes
#
#  index_day_of_sairans_on_report_id          (report_id)
#  index_day_of_sairans_on_report_id_and_day  (report_id,day) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (report_id => reports.id)
#
