# == Schema Information
#
# Table name: report_f_funin_factors
#
#  id                :bigint           not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  f_funin_factor_id :bigint           not null
#  report_id         :bigint           not null
#
# Indexes
#
#  index_report_f_funin_factors_on_f_funin_factor_id  (f_funin_factor_id)
#  index_report_f_funin_factors_on_report_id          (report_id)
#
# Foreign Keys
#
#  fk_rails_...  (f_funin_factor_id => f_funin_factors.id)
#  fk_rails_...  (report_id => reports.id)
#
require 'test_helper'

class ReportFFuninFactorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
