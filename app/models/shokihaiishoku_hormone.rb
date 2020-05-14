class ShokihaiishokuHormone < ApplicationRecord
  belongs_to :report, inverse_of: :shokihaiishoku_hormones

  validates :et, presence: true, numericality: true
end

# == Schema Information
#
# Table name: shokihaiishoku_hormones
#
#  id         :bigint           not null, primary key
#  e2         :float
#  et         :integer          not null
#  fsh        :float
#  hcg        :float
#  lh         :float
#  p4         :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  report_id  :bigint           not null
#
# Indexes
#
#  index_shokihaiishoku_hormones_on_report_id         (report_id)
#  index_shokihaiishoku_hormones_on_report_id_and_et  (report_id,et) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (report_id => reports.id)
#
