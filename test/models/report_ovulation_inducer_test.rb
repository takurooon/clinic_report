# == Schema Information
#
# Table name: report_ovulation_inducers
#
#  id                   :bigint           not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  ovulation_inducer_id :bigint           not null
#  report_id            :bigint           not null
#
# Indexes
#
#  index_report_ovulation_inducers_on_ovulation_inducer_id  (ovulation_inducer_id)
#  index_report_ovulation_inducers_on_report_id             (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (ovulation_inducer_id => ovulation_inducers.id)
#  fk_rails_...  (report_id => reports.id)
#

require 'test_helper'

class ReportOvulationInducerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
