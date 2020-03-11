# == Schema Information
#
# Table name: shokihaiishoku_hormones
#
#  id         :bigint           not null, primary key
#  e2         :integer
#  et         :integer          not null
#  fsh        :integer
#  hcg        :integer
#  lh         :integer
#  p4         :integer
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

require 'test_helper'

class ShokihaiishokuHormoneTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
