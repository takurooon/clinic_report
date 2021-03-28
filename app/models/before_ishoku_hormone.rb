class BeforeIshokuHormone < ApplicationRecord
  belongs_to :report, inverse_of: :before_ishoku_hormones

  validates :day, presence: { message: 'を選択してください。' }
end

# == Schema Information
#
# Table name: before_ishoku_hormones
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
#  index_before_ishoku_hormones_on_report_id          (report_id)
#  index_before_ishoku_hormones_on_report_id_and_day  (report_id,day) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (report_id => reports.id)
#
