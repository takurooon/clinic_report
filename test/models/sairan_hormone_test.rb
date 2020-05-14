# == Schema Information
#
# Table name: sairan_hormones
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
#  index_sairan_hormones_on_report_id          (report_id)
#  index_sairan_hormones_on_report_id_and_day  (report_id,day) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (report_id => reports.id)
#

require 'test_helper'

class SairanHormoneTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
